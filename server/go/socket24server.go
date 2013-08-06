package main

import (
	"bytes"
	"encoding/binary"
	"flag"
	"fmt"
	"net"
	"os"
	"strconv"
)

func main() {
	flag.Parse()
	if flag.NArg() < 2 {
		fmt.Println("输入的参数不正确,请重新输入.例如：socket22server 127.0.0.1 18083")
		os.Exit(0)
	}
	server := flag.Arg(0)
	port, _ := strconv.Atoi(flag.Arg(1))
	Server(server, port)
}

func Server(server string, port int) {
	exit := make(chan bool)
	ip := net.ParseIP(server)
	addr := net.TCPAddr{IP: ip, Port: port}
	go func() {
		listen, err := net.ListenTCP("tcp", &addr)
		if err != nil {
			fmt.Println("初始化失败", err.Error())
			exit <- true
			return
		}
		fmt.Println("正在监听...")
		for {
			client, err := listen.AcceptTCP()
			if err != nil {
				fmt.Println(err.Error())
				continue
			}
			defer client.Close()
			fmt.Println("客户端连接", client.RemoteAddr().String())

			data := make([]byte, 1024)
			c, err := client.Read(data)
			if err != nil {
				fmt.Println(err.Error())
			}
			if c == 0 {
				fmt.Println("read data:", c)
				continue
			}

			var mid int16
			var bodylen int32
			//var body []byte = make([]byte,1024)
			buf := bytes.NewBuffer(data)
			//return err from binary.Read
			binary.Read(buf, binary.BigEndian, &mid)
			binary.Read(buf, binary.BigEndian, &bodylen)

			fmt.Println("mid:", mid, "bodylen:", bodylen, "body:", string(data[6:c]))

			b := new(bytes.Buffer)
			bytes := []byte("hello simplemvc.")

			var blen int32 = int32(len(bytes))
			binary.Write(b, binary.BigEndian, mid)
			binary.Write(b, binary.BigEndian, blen)
			binary.Write(b, binary.BigEndian, bytes)

			client.Write(b.Bytes())
			fmt.Println("send data to client.")
		}
	}()
	<-exit
	fmt.Println("服务端关闭!")
}
