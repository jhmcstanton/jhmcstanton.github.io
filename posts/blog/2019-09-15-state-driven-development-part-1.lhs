---
title: State Driven Development Part 1
---

<details>
<summary>
When designing new programs it's frequently helpful to think about the various states it
can be in and design the program based on those states and their transitions. Unfortunately,
it's not all that common that we start off system design in a state-first manner, so its easy
for state to become overly complex, hidden, or surprising. In this post we'll try exploring
state driven development for a simple chat application.
</summary>

Imports and main needed to build the diagrams for this post.

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts  #-}
> {-# LANGUAGE TypeFamilies      #-}
>
> import Site.Posts.Literate
>
> imgDir = "images/posts/2019-09-15-state-driven-development-part-1/"
>
> renderTo :: FilePath -> Diagram B -> IO ()
> renderTo f d = renderSVG (imgDir ++ f) (mkWidth 1000) d
>
> main = mapM_ (uncurry renderTo) diagrams where
>   diagrams = map (fmap buffer) [stateMVP, clientMVP]
>
> state :: String -> Diagram B
> state name = text name # fontSize 18 <> unitCircle # named name
>
> cycleState :: String -> [String] -> Diagram B
> cycleState name transitions = transFontSize (foldr addCycle node (zip transitions offsets)) where
>   node = foldr ap (state name) (zipWith textBeside boxPositions transitions)
>   textBeside p "" a = a
>   textBeside p t  a = beside (r2 p) a (textBox t)
>   boxPositions = [(0, 1), (-1, 0), (0, -1), (1, 0)]
>   textBox t = text t <> strut 1
>   offsets = [fromIntegral (x*4 + 3) | x <- [0..length transitions]]
>   addCycle ("", _)         diag = diag
>   addCycle (trans, offset) diag = stateCycle name offset diag
>   ap f a = f a
>
> transFontSize :: Diagram B -> Diagram B
> transFontSize = fontSize 16
>
> stateCycle :: String -> Double {- arrow start -} -> Diagram B -> Diagram B
> stateCycle name start =
>   connectPerim' (with & arrowShaft .~ arc xDir (3/4 @@ turn)) name name (start/16 @@ turn) ((start + 2)/16 @@ turn)
>
> buffer :: Diagram B -> Diagram B
> buffer d = yBuff === (xBuff ||| d ||| xBuff) === yBuff
> yBuff = strutY 1
> xBuff = strutX 3
> tlrBuff s = (alignedText 0.5 0 s <> xBuff) # transFontSize
> skipCycle  = ""
>
> connectlr l r = connectPerim' (with & arrowShaft .~ arc yDir (-1/5 @@ turn)) l r (1/16 @@ turn) (7/16 @@ turn)
>

</details>

<h2>Initial Design</h2>

Chat applications are an interesting starting point for state driven development because
they are simple enough to easily wrap your head around but frequently grow in complexity.
The simple case we will start with is an application that is simply a server that can handle
broadcast requests from multiple clients, but in the future the application can be expanded
in various ways. The server could support authentication, multiple chat rooms, or bots. But for now,
let's keep this simple.

The application will be simply be a server with a common chat protocol over TCP, and an associated
client. The MVP before we make this application publicly available to users will be:


<ol>
<li>
A server that handles multiple clients with unique identities (but are not authenticated), and broadcasts
`send` requests between clients. The state diagram may look something like this:

<details>
<summary>
<img src="/images/posts/2019-09-15-state-driven-development-part-1/statemvp.svg"/>
</summary>
Code that generates this state diagram

> stateMVP :: (FilePath, Diagram B)
> stateMVP = ("statemvp.svg", listener ||| xBuff ||| handler)
>   where
>   listener = cycleState "Listen" ["connect"]
>   handler  = (connD ||| connToHandler ||| handlerD ||| handlerToClose ||| closeD)
>              # connectlr connected handle
>              # connectlr handle close
>   connToHandler = tlrBuff "identify"
>   handlerToClose = tlrBuff "close"
>   handlerD = cycleState handle ["broadcast", "", "list_users"]
>   connD = state connected
>   closeD   = circle 0.8 <> state close
>   handle   = "Handle"
>   connected = "Connected"
>   close    = "Close"

</details>

Note the two separate diagrams. These two represent the states of the two worker types of the server,
a socket listener and the client handler. The handler performs the work for each individual client,
supporting the actual main application logic. The socket listener simply waits for clients to make
connections and spawns worker handler threads for each client.
</li>

<li>
A client that connects to the server to send and receive messages.

<details>
<summary>
<img src="/images/posts/2019-09-15-state-driven-development-part-1/clientmvp.svg"/>
</summary>

Code that generates the client diagram.

> clientMVP :: (FilePath, Diagram B)
> clientMVP = ("clientmvp.svg", clientDiag) where
>   chatD = cycleState chat ["send", skipCycle, skipCycle, "receive"]
>   readyD = state ready
>   connectedD = (state connected) === toReady
>   connected = "Connected"
>   ready = "Ready"
>   chat  = "Chat"
>   readyToID = tlrBuff "connect"
>   idToChat  = tlrBuff "identify"
>   toReady   = (text "disconnect" <> strut 2) # transFontSize
>   clientDiag  = (readyD ||| readyToID ||| connectedD ||| idToChat ||| chatD)
>                 # connectlr ready connected
>                 # connectlr connected chat
>                 # connectPerim' (with & arrowShaft .~ arc yDir (-1/5 @@ turn)) chat ready (9/16 @@ turn) (-1/16 @@ turn)

</details>

For state simplicity this will be a simple single threaded client that
starts, connects to a host server, identifies its user, than provides
the basic chat functionality until a disconnect event.
</li>
</ol>

<h3>Server v0.1.0</h3>

halp
