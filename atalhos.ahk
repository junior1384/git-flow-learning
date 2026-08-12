#Requires AutoHotkey v2.0
#UseHook

$^q::
{
    try
    {
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("GET", "http://127.0.0.1:9222/json", false)
        http.Send()

        jsonText := http.ResponseText

        html := ComObject("htmlfile")
        html.write("<meta http-equiv='x-ua-compatible' content='IE=edge'>")
        js := html.parentWindow

        len := js.eval("(" jsonText ").length")

        Loop len
        {
            i := A_Index - 1

            type := js.eval("(" jsonText ")[" i "].type")
            url := js.eval("(" jsonText ")[" i "].url")
            id := js.eval("(" jsonText ")[" i "].id")

            if (
                type = "page"
                && (
                    InStr(url, "youtube.com")
                    || InStr(url, "youtu.be")
                    || InStr(url, "open.spotify.com")
                )
            )
            {
                closeReq := ComObject("WinHttp.WinHttpRequest.5.1")

                closeReq.Open(
                    "GET",
                    "http://127.0.0.1:9222/json/close/" id,
                    false
                )

                closeReq.Send()
            }
        }
    }
    catch
    {
        MsgBox "Não foi possível acessar o Brave na porta 9222."
    }
}

; ==========================================
; CTRL + B
; ==========================================

^b::
{
    Run '"C:\Users\junior.winkler\AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe" --remote-debugging-port=9222'
}