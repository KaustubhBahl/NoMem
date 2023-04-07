import 'package:crypto/crypto.dart';
import 'dart:convert';

String modify(int bv,int index,int sum,int pos1,int pos2,int pos3,int pos4)
{
  int x=0;
  int fv=((bv%77)*(index%77)*(sum%77))%77;
  if(index==pos1)
  {
    x=fv%15+'!'.codeUnitAt(0);
  }
  else if(index==pos2)
  {
    x=fv%26+'A'.codeUnitAt(0);
  }
  else if(index==pos3)
  {
    x=fv%26+'a'.codeUnitAt(0);
  }
  else if(index==pos4)
  {
    x=fv%10+'0'.codeUnitAt(0);
  }
  else
  {
    x=usual_modify(bv,index,sum);
  }
  return String.fromCharCode(x);
  
}  
int usual_modify(int bv,int index,int sum)
{
  int x;
  int fv=((bv%77)*(index%77)*(sum%77))%77;
  if(fv>=0 && fv<15)
  {
    x=fv%15+'!'.codeUnitAt(0);
  }
  else
  {
    if(fv>=15 && fv<41)
    {
      x=fv%26+'A'.codeUnitAt(0);
    }
    else
    {
      if(fv>=41 && fv<67)
      {
        x=fv%26+'a'.codeUnitAt(0);
      }
      else
      {
        x=fv%10+'0'.codeUnitAt(0);
      }
    } 
  }
  return x;
}
String passgen(String str,int len)
{
  int j=0;
  int sum=0;
  while(j<str.length)
  {
    sum=sum+str[j].codeUnitAt(0);
    j++;
  }
  int pos1,pos2,pos3,pos4;
  pos1=(len~/4)-1;
  pos2=2*(len~/4)-1;
  pos3=3*(len~/4)-1;
  pos4=4*(len~/4)-1;
  print('$pos1  $pos2  $pos3  $pos4\n');
  String password='';
  j=0;
  while(j<len)
  {
    password=password+modify(str[j].codeUnitAt(0),j,sum,pos1,pos2,pos3,pos4);
    j++;
  }
  return password;
}






class PasswordGen {
  final String domain, username, length, version, userKey;

  const PasswordGen(
      {required this.domain,
      required this.username,
      required this.length,
      required this.version,
      required this.userKey});

  String generatePassword() {
    final data = domain + username + length + version + userKey;
    var bytes = utf8.encode(data); // data being hashed
    var digest = sha512.convert(bytes);
    String digestHex = '$digest';
    var i = 0;
    var sum = 0;
    var len = int.parse(length);
    while (i < digestHex.length) {
      sum += digestHex[i].codeUnitAt(0);
      i++;
    }
    final password = passgen(digestHex,len);
    return password;
  }
}
