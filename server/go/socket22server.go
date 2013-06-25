package main

import (
    "fmt"
    "net"
    "strings"
    "os"
    "strconv"
    "flag"
)

func main(){
    flag.Parse()
    args := os.Args;
    if len(args)<2 {
        fmt.Println("输入的参数不正确,请重新输入.例如：socket22server 127.0.0.1 18083");
        os.Exit(0);
    }
    server := flag.Arg(0);
    port,_ := strconv.ParseInt(args[2],10)
    startServer(server,port)
}

func startServer(server string, port int64){
    exit := make(chan bool);
    ip := net.ParseIP(server);
    addr := net.TCPAddr{ip,port};
    go func(){
        listen,err := net.ListenTCP("tcp",&addr);
        if err!=nil {
            fmt.Println("初始化失败",err.Error());
            exit<- true;
            return;
        }
        fmt.Println("正在监听...");
        for {
            client,err := listen.AcceptTCP();
            if err!=nil {
                fmt.Println(err.Error());
                continue;
            }
            fmt.Println("客户端连接",client.RemoteAddr().String());
            data := make([]byte,1024);
            c,err := client.Read(data);
            if err !=nil {
                fmt.Println(err.Error());
            }
            fmt.Println(string(data[0:c]));
            client.Write([]byte("你好客户端!\r\n"));
            client.Close();
        }
    }();
    <-exit;
    fmt.Println("服务端关闭!");
}
