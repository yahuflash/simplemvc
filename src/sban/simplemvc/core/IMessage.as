package sban.simplemvc.core
{
	/**
	 * 异步消息模式
	 * 首次消息是一个指令，可以串发、并发及其串并组合发送与接收
	 * 
	 * 在pureMVC中，Proxy用于在Model与Server之间操作数据模型以保持Model
	 * 的高可扩展性与可移植性，在simpleMVC中，Proxy被Message取代。
	 *  
	 * @author sban
	 * 
	 */	
	public interface IMessage extends ICommand
	{
		
	}
}