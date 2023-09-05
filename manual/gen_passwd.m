% ElGamal Public Key Cryptosystem のサンプルをもとにしている
% openExample('comm/ElGamalPublicKeyCrypotsystemExample')
% 変更点はtext と　Display the encrypted message.　あたり
% textの設定は　組織名+担当者 担当者名はCapitalスタート
% 例　text = 'tcuSekiguchi';

% Use the Galois field array function, gf, to implement an ElGamal public key cryptosystem.
% Key Generation
% Define the polynomial degree, m.
m = 15;
q = 2^m;
%Find a primitive polynomial and group generator. Set the random number generator seed to produce a repeatable result.
poly = primpoly(m,'nodisplay');

primeFactors = unique(factor(2^m-1));
rng(123456);
while 1
    g = gf(randi([1,q-1]),m,poly);
    isPrimitive = true;
    for i = 1:length(primeFactors)
        if g^((q-1)/primeFactors(i)) == gf(1,m,poly)
            isPrimitive = false;
            break;
        end
    end
    if isPrimitive
        break;
    end
end
%Construct private and public keys.
privateKey = 12;
publicKey = {g,g^privateKey,poly};
%Encryption
%Create and display the original message.
text = 'tcuSekiguchi';
disp(text);
%Convert the message to binary and group them every m bits. The message uses ASCII characters. Since the ASCII table has 128 characters, seven bits per character is sufficient. 
bitsPerChar = m;
binMsg = int2bit(int8(text'),bitsPerChar);
numPaddedBits = m - mod(numel(binMsg),m);
if numPaddedBits == m
    numPaddedBits = 0;
end
binMsg = [binMsg; zeros(numPaddedBits,1)];
textToEncrypt = bit2int(binMsg,m);
%Encrypt the original message.
cipherText = gf(zeros(length(textToEncrypt),2),m,poly);

for i = 1:length(textToEncrypt)
    k = randi([1 2^m-2]);
    cipherText(i,:) = [publicKey{1}^k, ...
        gf(textToEncrypt(i),m,poly)*publicKey{2}^k];
end
%Display the encrypted message.
tmp = cipherText.x;
ch = mod(bit2int(int2bit(tmp(1:8,2),m),bitsPerChar),127);
ch(ch<33)=ch(ch<33) + 33;
string(char(ch)')
% % %de2char(tmp(:,2),bitsPerChar,m)
% % %Decryption
% % %Decrypt the encrypted original message.
% % decipherText = gf(zeros(size(cipherText,1),1),m,poly);
% % for i = 1:size(cipherText,1)
% %     decipherText(i) = cipherText(i,2) * cipherText(i,1)^(-privateKey);
% % end
% % %Display the decrypted message.
% % %disp(de2char(decipherText.x,bitsPerChar,m));
% % 
% % %Supporting Function
% % %de2char converts the bits to char messages.
% % function text = de2char(msg,bitsPerChar,m)
% % binDecipherText = int2bit(msg,m);
% % text = char(bit2int(binDecipherText(1:end-mod(numel(binDecipherText), ...
% %     bitsPerChar)),bitsPerChar))';
% % end
