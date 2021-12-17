import string

filename = "input"

class Packet:
    def __init__(self, version, id):
        self.version = version
        self.id = id
        self.value = None

    def __str__(self):
        return "{{id: {}, version: {}, value: {} }}".format(self.id, self.version, self.value)

    def __repr__(self) -> str:
        return self.__str__()

    def setLiteral(self, literal):
        self.value = literal
    
    def addPacket(self, packet):
        if type(self.value) is list:
            self.value.append(packet)
        else:
            self.value = [packet]
    
    def evaluate(self):
        if type(self.value) is list:
            if self.id == 0:
                total = 0
                for p in self.value:
                    total += p.evaluate()
                return total
            elif self.id == 1:
                total = 1
                for p in self.value:
                    total *= p.evaluate()
                return total
            elif self.id == 2:
                # minimum
                return min([v.evaluate() for v in self.value])
            elif self.id == 3:
                return max([v.evaluate() for v in self.value])
            elif self.id == 5:
                # 1 if first packet is bigger
                v1 = self.value[0].evaluate()
                v2 = self.value[1].evaluate()
                return 1 if v1 > v2 else 0
            elif self.id == 6:
                # 1 if first packet is smaller
                v1 = self.value[0].evaluate()
                v2 = self.value[1].evaluate()
                return 1 if v1 < v2 else 0
            elif self.id == 7:
                # 1 if packets are equal
                v1 = self.value[0].evaluate()
                v2 = self.value[1].evaluate()
                return 1 if v1 == v2 else 0
        else:
            return self.value

class FakeBitReader:
    def __init__(self, filename):
        self.f = open(filename)
        self.buf = self.__readAsIfByte__()
        self.remaining = 8
    
    def readBits(self, count):
        if self.remaining > count:
            rem = self.remaining - count
            answer = self.buf >> rem
            if rem > 0:
                # more bytes left in buffer, so we need to shift
                # those right so they're on the edge
                #
                # Say we had seven bytes: [_ 1 0 1 1 0 0 1]
                # we request 3, so rem is 4
                self.remaining = rem
                mask = 0xFF >> (8 - rem)
                self.buf = self.buf & mask
            else:
                self.__reset__()
            return answer
        else:
            # if there are 3 bytes and we want 5, then
            # we want remaining and then 2 spaces (shift left by 2)
            hangover = count - self.remaining
            result = self.buf << (hangover)
            self.__reset__()
            result2 = self.readBits(hangover)
            return result | result2

    def __reset__(self):
        self.buf = self.__readAsIfByte__()
        self.remaining = 8

    def __readAsIfByte__(self):
        return int(self.f.read(2),16)

### Reads a packet, assuming the fake bit reader is at the start of one
def parsePacket(fbr):

    version = fbr.readBits(3)
    id = fbr.readBits(3)
    packetLength = 6

    p = Packet(version, id)

    if id == 4:
        value = 0
        flag = fbr.readBits(1)
        packetLength+=1
        while flag == 1:
            value = value + fbr.readBits(4)
            value = value << 4
            flag = fbr.readBits(1)
            packetLength+=5
        # flag is 0
        value = value + fbr.readBits(4)
        packetLength+=4
        p.setLiteral(value)
    else:
        # for now we only care about packet hierarchy parsing
        # so this is for any operator id
        lengthTypeID = fbr.readBits(1)
        packetLength+=1
        length = 0
        if lengthTypeID == 0:
            length = fbr.readBits(15)
            packetLength+=15
            # this length is the number of bits of subpackets
            readBits = 0
            while readBits < length:
                (pk, l) = parsePacket(fbr)
                readBits += l
                packetLength+=l
                p.addPacket(pk)
        else:
            length = fbr.readBits(11)
            packetLength+=11
            # this length is the number of subpackets directly
            for _ in range(length):
                (pk,l) = parsePacket(fbr)
                p.addPacket(pk)
                packetLength+=l
        

    return (p, packetLength)
    
def isValid(c):
    return c != "" and c != "\n" and c != " "


def main():
    f = open(filename) # read/text implied

    # there should be one (really long) line that we can process one character at a time
    br = FakeBitReader(filename)

    (p, l) = parsePacket(br)

    # print(p, l)
    print(p.evaluate())

main()