package us.sban.simplemvc.util
{
	public final class StringUtil
	{
		public static function contains(s:String,substr:String,ignoreCase:Boolean=false):Boolean
		{
			if (ignoreCase)
				return s.toLowerCase().indexOf(substr.toLowerCase()) >= 0;
			return s.indexOf(substr) >= 0;
		}
		
		public static function startWith(s:String, substr:String,ignoreCase:Boolean=false):Boolean{
			return (new RegExp('^'+substr, ignoreCase ? 'i' : null)).test(s);
		}
		public static function endWith(s:String, substr:String,ignoreCase:Boolean=false):Boolean{
			return (new RegExp(substr + '$', ignoreCase ? 'i' : null)).test(s);
		}
		
		public static function isNullOrEmpty(s:String):Boolean{
			return null == s || s.length == 0 || s.match(/^[\s]+$/);
		}
		
		/**
		 * 格式化字符串，支持字符，浮点，整型，日期/时间，八/十六进制
		 * 支持的格式符号：
		 * s: string
		 * f: Outputs as a Number, can use the precision specifier: %.2sf will output a float with 2 decimal digits
		 * d: Outputs as an Integer
		 * o: Converts to an OCTAL number
		 * x: Converts to a Hexa number (includes 0x) 
		 * b: Convert to binary number，输出的是原码，没有符号位，前面空位没有补0
		 * D: Day of month, from 01 to 30
		 * Y: Full year, e.g. 2007
		 * y: Year, e.g. 07
		 * M: Month from 01 to 12
		 * H: Hours (0-23)
		 * h: Hours (0-12)
		 * p: AM or PM
		 * m: Minutes (00-59)
		 * s: Seconds (00-59)
		 * c: date local string
		 * 
		 * 示例：
		 * <pre>
		 * format("This is an %s utillity for formating %s", "as3", "strings");
		 * outputs: "This is an as3 utillity for formating strings";
		 * 
		 * format("You can also display numbers like PI: %f, and format them to a fixed precision, such as PI with 3 decimal places %.3f", Math.PI, Math.PI);
		 * outputs: " You can also display numbers like PI: 3.141592653589793, and format them to a fixed precision, such as PI with 3 decimal places 3.142"
		 * 
		 * var date : Date = new Date();
		 * format("Today is %D/%M/%Y", date, date, date)
		 * </pre>
		 * 
		 * 该方法修改自Arthur Debert的《Announcing as-printf》：http://www.stimuli.com.br/trane/2009/feb/21/printf-as3/
		 * 感谢Arthur Debert！
		 *  
		 * @param source
		 * @param rest
		 * @return 
		 * 
		 */		
		public static function format(s : String, ...rest):String
		{
			/** Converts to a string*/
			const STRING_FORMATTER : String = "s";
			/** Outputs as a Number, can use the precision specifier: %.2sf will output a float with 2 decimal digits.*/
			const FLOAT_FORMATER : String = "f";
			/** Outputs as an Integer.*/
			const INTEGER_FORMATER : String = "d";
			/** Converts to an OCTAL number */
			const OCTAL_FORMATER : String = "o";
			/** Converts to a Hexa number (includes 0x) */
			const HEXA_FORMATER : String = "x";
			/** Converts to a binary number */
			const BIN_FORMATER : String = "b";
			/** @private */
			const DATES_FORMATERS : String = "DYyMHhpmsc";
			/** Day of month, from 0 to 30 on <code>Date</code> objects.*/
			const DATE_DAY_FORMATTER : String = "D";
			/** Full year, e.g. 2007 on <code>Date</code> objects.*/
			const DATE_FULLYEAR_FORMATTER : String = "Y";
			/** Year, e.g. 07 on <code>Date</code> objects.*/
			const DATE_YEAR_FORMATTER : String = "y";
			/** Month from 1 to 12 on <code>Date</code> objects.*/
			const DATE_MONTH_FORMATTER : String = "M";
			/** Hours (0-23) on <code>Date</code> objects.*/
			const DATE_HOUR24_FORMATTER : String = "H";
			/** Hours 0-12 on <code>Date</code> objects.*/
			const DATE_HOUR_FORMATTER : String = "h";
			/** AM or PM on <code>Date</code> objects.*/
			const DATE_HOUR_AMPM_FORMATTER : String = "p";
			/** Minutes on <code>Date</code> objects.*/
			const DATE_MINUTES_FORMATTER : String = "m";
			/** Seconds on <code>Date</code> objects.*/
			const DATE_SECONDS_FORMATTER : String = "s";
			/** A string rep of a <code>Date</code> object on the current locale.*/
			const DATE_TOLOCALE_FORMATTER : String = "c";
			const formatRegExp : RegExp = /% (?P<padding>[0-9]{1,2})? (\.(?P<precision>[0-9]+))? (?P<formater>[sfdoxbDYymHIpMSc]) /igx;
		
//			trace(s,rest);
			var results :Array=[];
			var result : Object;
			var formater:String,precision:String,padding:String;
			var paddingNum : int;
			var paddingChar:String;
			var replaceValueIndex:int=0;
			var replacementValue:Object;
			var previous : String;
			var lastIndex:int=0,startIndex:int,endIndex:int;
			var replacement:Object;
			
			while(result = formatRegExp.exec(s))
			{
				formater = result.formater;
				padding = result.padding;
				precision = result.precision;
				
				startIndex = result.index;
				endIndex = startIndex + result[0].length;
				
				previous = s.substring(lastIndex, startIndex);
				lastIndex = endIndex;
				results.push( previous );
				
				//%03d,%12d,取出paddingChar,paddingNum
				if (padding){
					if(padding.charAt(0)=="0")
					{
						paddingChar = "0";
						paddingNum = int(padding.substr(1));
					}else{
						paddingChar = " ";
						paddingNum = int(padding.substr(0));
					}
				}
				
				replacementValue = rest[replaceValueIndex++];
				
				switch (formater){
					case STRING_FORMATTER:
						replacement = pad(String(replacementValue), paddingNum, paddingChar);
						break;
					case FLOAT_FORMATER:
						if (precision){
							replacement = pad( 
								Number(replacementValue).toFixed( int(precision)),
								paddingNum, 
								paddingChar);
						}else{
							replacement = pad(String(replacementValue), paddingNum, paddingChar);
						}
						break;
					case INTEGER_FORMATER:
						replacement = pad(int(replacementValue).toString(), paddingNum, paddingChar);
						break;
					case OCTAL_FORMATER:
						replacement = "0" + int(replacementValue).toString(8);
						break;
					case HEXA_FORMATER:
						replacement = "0x" + int(replacementValue).toString(16);
						break;
					case BIN_FORMATER:
						replacement = (replacementValue as int).toString(2);
						break;
					case DATE_DAY_FORMATTER:
						replacement = pad(String(replacementValue["date"]),2,"0");
						break;
					case DATE_FULLYEAR_FORMATTER:
						replacement = replacementValue["fullYear"];
						break;
					case DATE_YEAR_FORMATTER:
						replacement = String(replacementValue["fullYear"]).substr(2, 2);
						break;
					case DATE_MONTH_FORMATTER:
						replacement = pad(String(replacementValue["month"] + 1),2,"0");
						break;
					case DATE_HOUR24_FORMATTER:
						replacement = pad(String(replacementValue["hours"]),2,"0");
						break;
					case DATE_HOUR_FORMATTER:
						var hours24 : Number = replacementValue["hours"];
						replacement =  pad((hours24 -12).toString(),2,"0");
						break;
					case DATE_HOUR_AMPM_FORMATTER:
						replacement =  (replacementValue["hours"]  >= 12 ? "PM" : "AM");
						break;
					case DATE_TOLOCALE_FORMATTER:
						replacement = (replacementValue as Date).toLocaleString();
						break;
					case DATE_MINUTES_FORMATTER:
						replacement = pad(String(replacementValue["minutes"]),2,"0");
						break;
					case DATE_SECONDS_FORMATTER:
						replacement = pad(String(replacementValue["seconds"]),2,"0");
						break;    
				}
					
				results.push( replacement );
			}
			
			if(results.length == 0){
				return s;
			}else{
				results.push(s.substr(endIndex, s.length - endIndex));
			}
			
			return results.join("");
		}
		
		/**
		 * 在字符串前面补足指定字符以达到指定位数
		 * 
		 * @param str 需前补齐的原字符串
		 * @param paddingNum 补齐后是几位
		 * @param paddingChar 充当空位的字符
		 * @return 
		 * 
		 */		
		public static function pad(s:String, num:int, char:String=" ") : String
		{
			return new Array(num).join(char).substr(0,num-s.length).concat(s);
		}
		
		public static function removeWhitespace(s:String):String
		{
			const WHITESPACE:RegExp = /[\s\r\n]*/gim;
			return s.replace(WHITESPACE, '');
		}
	}
}
