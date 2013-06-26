package main

import (
    "fmt"
    "net"
    "os"
    "strconv"
    "flag"
    "bytes"
    "encoding/binary"
)

func main(){
    flag.Parse()
    if flag.NArg() < 2 {
        fmt.Println("输入的参数不正确,请重新输入.例如：socket22server 127.0.0.1 18083");
        os.Exit(0);
    }
    server := flag.Arg(0);
    port,_ := strconv.Atoi(flag.Arg(1))
    Client(server,port)
}

func Client(server string, port int){
    client,err := net.Dial("tcp",server+":"+strconv.Itoa(port));
    if err!=nil {
        fmt.Println("服务端连接失败",err.Error());
        return;
    }
    defer client.Close()

    b := new(bytes.Buffer)
    var mid int16 = 1
    var body []byte = []byte("Hello Server!")
    var bodylen int32 = int32( len(body) )

    binary.Write(b,binary.BigEndian,mid)
    binary.Write(b,binary.BigEndian,bodylen)
    binary.Write(b,binary.BigEndian,body)

    client.Write(b.Bytes());
    fmt.Println("send to server:",string(body),"len:",len(body),"bodylen:",bodylen)

    buf := make([]byte,1024);
    c,err := client.Read(buf);
    if err!=nil {
        fmt.Println(err.Error());
        return;
    }
    fmt.Println(string(buf[0:c]));
}
