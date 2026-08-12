; ==========================================
; CTRL + Q → Fecha YouTube + Spotify
; ==========================================
^q::
{
    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", "http://127.0.0.1:9222/json", false)
    http.Send()

    json := http.ResponseText
    pos := 1
    ids := []

    ; Coleta todas as abas do YouTube
    while RegExMatch(json, 's)"id"\s*:\s*"([^"]+)".*?"type"\s*:\s*"page".*?"url"\s*:\s*"([^"]+)"', &m, pos)
    {
        id := m[1]
        url := m[2]
        pos := m.Pos + m.Len

        if InStr(url, "youtube.com") || InStr(url, "youtu.be")
            ids.Push(id)
    }

    ; Fecha todas as abas do YouTube
    for id in ids
    {
        close := ComObject("WinHttp.WinHttpRequest.5.1")
        close.Open("GET", "http://127.0.0.1:9222/json/close/" id, false)
        close.Send()
    }

    ; Fecha o Spotify
    SetTitleMatchMode 2

    if WinExist("Spotify")
        WinClose("Spotify")
}


; ==========================================
; CTRL + B → Abre Brave
; ==========================================
^b::
{
    Run "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
}