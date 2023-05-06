
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc b0 0a 11 80       	mov    $0x80110ab0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 0a 11 80       	mov    $0x80110af4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 78 10 80       	push   $0x80107820
80100055:	68 c0 0a 11 80       	push   $0x80110ac0
8010005a:	e8 01 4a 00 00       	call   80104a60 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 51 11 80       	mov    $0x801151bc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 52 11 80 bc 	movl   $0x801151bc,0x8011520c
8010006e:	51 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 52 11 80 bc 	movl   $0x801151bc,0x80115210
80100078:	51 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 51 11 80 	movl   $0x801151bc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 78 10 80       	push   $0x80107827
80100097:	50                   	push   %eax
80100098:	e8 83 48 00 00       	call   80104920 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 52 11 80       	mov    0x80115210,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 52 11 80    	mov    %ebx,0x80115210
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 4f 11 80    	cmp    $0x80114f60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 0a 11 80       	push   $0x80110ac0
801000e8:	e8 f3 4a 00 00       	call   80104be0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 52 11 80    	mov    0x80115210,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 51 11 80    	cmp    $0x801151bc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 51 11 80    	cmp    $0x801151bc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 52 11 80    	mov    0x8011520c,%ebx
80100126:	81 fb bc 51 11 80    	cmp    $0x801151bc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 51 11 80    	cmp    $0x801151bc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 0a 11 80       	push   $0x80110ac0
80100162:	e8 39 4b 00 00       	call   80104ca0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 47 00 00       	call   80104960 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 78 10 80       	push   $0x8010782e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 39 48 00 00       	call   80104a00 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 78 10 80       	push   $0x8010783f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 f8 47 00 00       	call   80104a00 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 a8 47 00 00       	call   801049c0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 0a 11 80 	movl   $0x80110ac0,(%esp)
8010021f:	e8 bc 49 00 00       	call   80104be0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 52 11 80       	mov    0x80115210,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 51 11 80 	movl   $0x801151bc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 52 11 80       	mov    0x80115210,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 52 11 80    	mov    %ebx,0x80115210
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 0a 11 80 	movl   $0x80110ac0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 2b 4a 00 00       	jmp    80104ca0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 78 10 80       	push   $0x80107846
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 2a 49 00 00       	call   80104be0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801002cb:	3b 05 a4 54 11 80    	cmp    0x801154a4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 54 11 80       	push   $0x801154a0
801002e5:	e8 b6 40 00 00       	call   801043a0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 54 11 80    	cmp    0x801154a4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 e1 38 00 00       	call   80103be0 <myproc>
801002ff:	8b 48 38             	mov    0x38(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 8d 49 00 00       	call   80104ca0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 54 11 80    	mov    %edx,0x801154a0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 54 11 80 	movsbl -0x7feeabe0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 36 49 00 00       	call   80104ca0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 54 11 80       	mov    %eax,0x801154a0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 78 10 80       	push   $0x8010784d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 2b 7e 10 80 	movl   $0x80107e2b,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 9f 46 00 00       	call   80104a80 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 78 10 80       	push   $0x80107861
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 f1 5f 00 00       	call   80106420 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 06 5f 00 00       	call   80106420 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 fa 5e 00 00       	call   80106420 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ee 5e 00 00       	call   80106420 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 48 00 00       	call   80104d90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 47 00 00       	call   80104cf0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 78 10 80       	push   $0x80107865
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 78 10 80 	movzbl -0x7fef8770(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 7c 45 00 00       	call   80104be0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 04 46 00 00       	call   80104ca0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 78 78 10 80       	mov    $0x80107878,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 1e 44 00 00       	call   80104be0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 73 44 00 00       	call   80104ca0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 78 10 80       	push   $0x8010787f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 64 43 00 00       	call   80104be0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 54 11 80       	mov    0x801154a8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 54 11 80    	sub    0x801154a0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 54 11 80    	mov    %ecx,0x801154a8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 54 11 80    	mov    %bl,-0x7feeabe0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 54 11 80       	mov    0x801154a0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 54 11 80    	cmp    %eax,0x801154a8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 54 11 80       	mov    0x801154a8,%eax
80100925:	39 05 a4 54 11 80    	cmp    %eax,0x801154a4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 54 11 80 0a 	cmpb   $0xa,-0x7feeabe0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 54 11 80       	mov    %eax,0x801154a8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 54 11 80       	mov    0x801154a8,%eax
8010096f:	3b 05 a4 54 11 80    	cmp    0x801154a4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 54 11 80       	mov    0x801154a8,%eax
80100985:	3b 05 a4 54 11 80    	cmp    0x801154a4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 54 11 80       	mov    %eax,0x801154a8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 cc 42 00 00       	call   80104ca0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 54 11 80 0a 	movb   $0xa,-0x7feeabe0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 6c 3c 00 00       	jmp    80104670 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 54 11 80       	mov    0x801154a8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 54 11 80       	mov    %eax,0x801154a4
          wakeup(&input.r);
80100a1b:	68 a0 54 11 80       	push   $0x801154a0
80100a20:	e8 4b 3b 00 00       	call   80104570 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 88 78 10 80       	push   $0x80107888
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 17 40 00 00       	call   80104a60 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 5e 11 80 40 	movl   $0x80100640,0x80115e6c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 5e 11 80 90 	movl   $0x80100290,0x80115e68
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 4b 31 00 00       	call   80103be0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 06 03 00 00    	je     80100dbc <exec+0x33c>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 7f 6a 00 00       	call   80107590 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 ac 02 00 00    	je     80100ddb <exec+0x35b>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 38 68 00 00       	call   801073b0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 32 67 00 00       	call   801072e0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 20 69 00 00       	call   80107510 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 8a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 79 67 00 00       	call   801073b0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 d8 69 00 00       	call   80107630 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 48 42 00 00       	call   80104ef0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 35 42 00 00       	call   80104ef0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 c4 6a 00 00       	call   80107790 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 2a 68 00 00       	call   80107510 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 58 6a 00 00       	call   80107790 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 e8 80             	sub    $0xffffff80,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 3a 41 00 00       	call   80104eb0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 18             	mov    0x18(%edi),%edi
  curproc->prio = 2;
80100d81:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  curproc->pgdir = pgdir;
80100d88:	89 48 18             	mov    %ecx,0x18(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d8b:	89 c1                	mov    %eax,%ecx
  curproc->sz = sz;
80100d8d:	89 70 14             	mov    %esi,0x14(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d90:	8b 40 2c             	mov    0x2c(%eax),%eax
80100d93:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d99:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d9c:	8b 41 2c             	mov    0x2c(%ecx),%eax
80100d9f:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100da2:	89 0c 24             	mov    %ecx,(%esp)
80100da5:	e8 a6 63 00 00       	call   80107150 <switchuvm>
  freevm(oldpgdir);
80100daa:	89 3c 24             	mov    %edi,(%esp)
80100dad:	e8 5e 67 00 00       	call   80107510 <freevm>
  return 0;
80100db2:	83 c4 10             	add    $0x10,%esp
80100db5:	31 c0                	xor    %eax,%eax
80100db7:	e9 34 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dbc:	e8 ef 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	68 a1 78 10 80       	push   $0x801078a1
80100dc9:	e8 e2 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dce:	83 c4 10             	add    $0x10,%esp
80100dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd6:	e9 15 fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ddb:	31 ff                	xor    %edi,%edi
80100ddd:	be 00 20 00 00       	mov    $0x2000,%esi
80100de2:	e9 31 fe ff ff       	jmp    80100c18 <exec+0x198>
80100de7:	66 90                	xchg   %ax,%ax
80100de9:	66 90                	xchg   %ax,%ax
80100deb:	66 90                	xchg   %ax,%ax
80100ded:	66 90                	xchg   %ax,%ax
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 ad 78 10 80       	push   $0x801078ad
80100dff:	68 c0 54 11 80       	push   $0x801154c0
80100e04:	e8 57 3c 00 00       	call   80104a60 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 54 11 80       	mov    $0x801154f4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 54 11 80       	push   $0x801154c0
80100e25:	e8 b6 3d 00 00       	call   80104be0 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 5e 11 80    	cmp    $0x80115e54,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 54 11 80       	push   $0x801154c0
80100e51:	e8 4a 3e 00 00       	call   80104ca0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 54 11 80       	push   $0x801154c0
80100e6a:	e8 31 3e 00 00       	call   80104ca0 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 54 11 80       	push   $0x801154c0
80100e93:	e8 48 3d 00 00       	call   80104be0 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 54 11 80       	push   $0x801154c0
80100eb0:	e8 eb 3d 00 00       	call   80104ca0 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 b4 78 10 80       	push   $0x801078b4
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 54 11 80       	push   $0x801154c0
80100ee5:	e8 f6 3c 00 00       	call   80104be0 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 54 11 80       	push   $0x801154c0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 7b 3d 00 00       	call   80104ca0 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 54 11 80 	movl   $0x801154c0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 4d 3d 00 00       	jmp    80104ca0 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 bc 78 10 80       	push   $0x801078bc
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 c6 78 10 80       	push   $0x801078c6
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 cf 78 10 80       	push   $0x801078cf
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 d5 78 10 80       	push   $0x801078d5
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 5e 11 80    	add    0x80115ed8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 df 78 10 80       	push   $0x801078df
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 5e 11 80    	mov    0x80115ec0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 5e 11 80    	add    0x80115ed8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 5e 11 80    	cmp    %eax,0x80115ec0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 78 10 80       	push   $0x801078f2
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 c6 39 00 00       	call   80104cf0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 5f 11 80       	mov    $0x80115f14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 5e 11 80       	push   $0x80115ee0
8010136a:	e8 71 38 00 00       	call   80104be0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 7b 11 80    	cmp    $0x80117b34,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 7b 11 80    	cmp    $0x80117b34,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 5e 11 80       	push   $0x80115ee0
801013d7:	e8 c4 38 00 00       	call   80104ca0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 5e 11 80       	push   $0x80115ee0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 96 38 00 00       	call   80104ca0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 7b 11 80    	cmp    $0x80117b34,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 08 79 10 80       	push   $0x80107908
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 18 79 10 80       	push   $0x80107918
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 56 38 00 00       	call   80104d90 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 5f 11 80       	mov    $0x80115f20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 2b 79 10 80       	push   $0x8010792b
80101565:	68 e0 5e 11 80       	push   $0x80115ee0
8010156a:	e8 f1 34 00 00       	call   80104a60 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 32 79 10 80       	push   $0x80107932
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 94 33 00 00       	call   80104920 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 7b 11 80    	cmp    $0x80117b40,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 5e 11 80       	push   $0x80115ec0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 5e 11 80    	pushl  0x80115ed8
801015ad:	ff 35 d4 5e 11 80    	pushl  0x80115ed4
801015b3:	ff 35 d0 5e 11 80    	pushl  0x80115ed0
801015b9:	ff 35 cc 5e 11 80    	pushl  0x80115ecc
801015bf:	ff 35 c8 5e 11 80    	pushl  0x80115ec8
801015c5:	ff 35 c4 5e 11 80    	pushl  0x80115ec4
801015cb:	ff 35 c0 5e 11 80    	pushl  0x80115ec0
801015d1:	68 98 79 10 80       	push   $0x80107998
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 5e 11 80 01 	cmpl   $0x1,0x80115ec8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 5e 11 80    	cmp    0x80115ec8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 5e 11 80    	add    0x80115ed4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 7d 36 00 00       	call   80104cf0 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 38 79 10 80       	push   $0x80107938
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 5e 11 80    	add    0x80115ed4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 76 36 00 00       	call   80104d90 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 5e 11 80       	push   $0x80115ee0
80101753:	e8 88 34 00 00       	call   80104be0 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80101763:	e8 38 35 00 00       	call   80104ca0 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 c5 31 00 00       	call   80104960 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 5e 11 80    	add    0x80115ed4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 83 35 00 00       	call   80104d90 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 50 79 10 80       	push   $0x80107950
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 4a 79 10 80       	push   $0x8010794a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 94 31 00 00       	call   80104a00 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 38 31 00 00       	jmp    801049c0 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 5f 79 10 80       	push   $0x8010795f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 a7 30 00 00       	call   80104960 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 ed 30 00 00       	call   801049c0 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
801018da:	e8 01 33 00 00       	call   80104be0 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 5e 11 80 	movl   $0x80115ee0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 a7 33 00 00       	jmp    80104ca0 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 5e 11 80       	push   $0x80115ee0
80101908:	e8 d3 32 00 00       	call   80104be0 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80101917:	e8 84 33 00 00       	call   80104ca0 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 74 32 00 00       	call   80104d90 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 5e 11 80 	mov    -0x7feea1a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 78 31 00 00       	call   80104d90 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 5e 11 80 	mov    -0x7feea19c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 49 31 00 00       	call   80104e00 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 e6 30 00 00       	call   80104e00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 79 79 10 80       	push   $0x80107979
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 67 79 10 80       	push   $0x80107967
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 41 1e 00 00       	call   80103be0 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 7c             	mov    0x7c(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 5e 11 80       	push   $0x80115ee0
80101dac:	e8 2f 2e 00 00       	call   80104be0 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80101dbc:	e8 df 2e 00 00       	call   80104ca0 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 64 2f 00 00       	call   80104d90 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 d8 2e 00 00       	call   80104d90 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 66 2e 00 00       	call   80104e50 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 88 79 10 80       	push   $0x80107988
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 2e 80 10 80       	push   $0x8010802e
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 f4 79 10 80       	push   $0x801079f4
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 eb 79 10 80       	push   $0x801079eb
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 06 7a 10 80       	push   $0x80107a06
8010216f:	68 80 b5 10 80       	push   $0x8010b580
80102174:	e8 e7 28 00 00       	call   80104a60 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 82 11 80       	mov    0x80118200,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 b5 10 80       	push   $0x8010b580
80102202:	e8 d9 29 00 00       	call   80104be0 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 0e 23 00 00       	call   80104570 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 b5 10 80       	push   $0x8010b580
8010227b:	e8 20 2a 00 00       	call   80104ca0 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 59 27 00 00       	call   80104a00 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 b5 10 80       	push   $0x8010b580
801022dc:	e8 ff 28 00 00       	call   80104be0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 b5 10 80       	push   $0x8010b580
80102328:	53                   	push   %ebx
80102329:	e8 72 20 00 00       	call   801043a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 55 29 00 00       	jmp    80104ca0 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 35 7a 10 80       	push   $0x80107a35
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 20 7a 10 80       	push   $0x80107a20
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 0a 7a 10 80       	push   $0x80107a0a
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 7b 11 80 00 	movl   $0xfec00000,0x80117b34
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 7b 11 80    	mov    0x80117b34,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 7b 11 80    	mov    0x80117b34,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 7c 11 80 	movzbl 0x80117c60,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 54 7a 10 80       	push   $0x80107a54
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 7b 11 80    	mov    0x80117b34,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 7b 11 80    	mov    0x80117b34,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 7b 11 80    	mov    0x80117b34,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 7b 11 80    	mov    0x80117b34,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 7b 11 80    	mov    0x80117b34,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 7b 11 80       	mov    0x80117b34,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb c8 ae 11 80    	cmp    $0x8011aec8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 35 28 00 00       	call   80104cf0 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 7b 11 80    	mov    0x80117b74,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 7b 11 80       	mov    0x80117b78,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 7b 11 80       	mov    0x80117b74,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 7b 11 80    	mov    %ebx,0x80117b78
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 7b 11 80       	push   $0x80117b40
801024f0:	e8 eb 26 00 00       	call   80104be0 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 7b 11 80 	movl   $0x80117b40,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 90 27 00 00       	jmp    80104ca0 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 86 7a 10 80       	push   $0x80107a86
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 8c 7a 10 80       	push   $0x80107a8c
80102584:	68 40 7b 11 80       	push   $0x80117b40
80102589:	e8 d2 24 00 00       	call   80104a60 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 7b 11 80 00 	movl   $0x0,0x80117b74
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 7b 11 80 01 	movl   $0x1,0x80117b74
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 7b 11 80       	mov    0x80117b74,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 7b 11 80       	mov    0x80117b78,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 7b 11 80    	mov    %edx,0x80117b78
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 7b 11 80       	push   $0x80117b40
80102673:	e8 68 25 00 00       	call   80104be0 <acquire>
  r = kmem.freelist;
80102678:	a1 78 7b 11 80       	mov    0x80117b78,%eax
  if(r)
8010267d:	8b 15 74 7b 11 80    	mov    0x80117b74,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 7b 11 80    	mov    %ecx,0x80117b78
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 7b 11 80       	push   $0x80117b40
801026a1:	e8 fa 25 00 00       	call   80104ca0 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a c0 7b 10 80 	movzbl -0x7fef8440(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 c0 7a 10 80 	movzbl -0x7fef8540(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 a0 7a 10 80 	mov    -0x7fef8560(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a c0 7b 10 80 	movzbl -0x7fef8440(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 7b 11 80       	mov    0x80117b7c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 7b 11 80       	mov    0x80117b7c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 7b 11 80       	mov    0x80117b7c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 7b 11 80       	mov    0x80117b7c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 6c 22 00 00       	call   80104d40 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 7b 11 80    	mov    0x80117bc8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 7b 11 80       	mov    0x80117bb4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 7b 11 80    	pushl  0x80117bc4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 7b 11 80 	pushl  -0x7fee8434(,%edi,4)
80102be4:	ff 35 c4 7b 11 80    	pushl  0x80117bc4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 87 21 00 00       	call   80104d90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 7b 11 80    	cmp    %edi,0x80117bc8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 7b 11 80    	pushl  0x80117bb4
80102c4d:	ff 35 c4 7b 11 80    	pushl  0x80117bc4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 7b 11 80       	mov    0x80117bc8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 7b 11 80 	mov    -0x7fee8434(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 c0 7c 10 80       	push   $0x80107cc0
80102cb3:	68 80 7b 11 80       	push   $0x80117b80
80102cb8:	e8 a3 1d 00 00       	call   80104a60 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 7b 11 80    	mov    %ebx,0x80117bc4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 7b 11 80       	mov    %eax,0x80117bb4
  log.size = sb.nlog;
80102cdb:	89 15 b8 7b 11 80    	mov    %edx,0x80117bb8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 7b 11 80    	mov    %ecx,0x80117bc8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 7b 11 80 	mov    %ebx,-0x7fee8434(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 7b 11 80 00 	movl   $0x0,0x80117bc8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 7b 11 80       	push   $0x80117b80
80102d4f:	e8 8c 1e 00 00       	call   80104be0 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 7b 11 80       	push   $0x80117b80
80102d68:	68 80 7b 11 80       	push   $0x80117b80
80102d6d:	e8 2e 16 00 00       	call   801043a0 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 7b 11 80       	mov    0x80117bc0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 7b 11 80       	mov    0x80117bbc,%eax
80102d83:	8b 15 c8 7b 11 80    	mov    0x80117bc8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 7b 11 80       	mov    %eax,0x80117bbc
      release(&log.lock);
80102d9f:	68 80 7b 11 80       	push   $0x80117b80
80102da4:	e8 f7 1e 00 00       	call   80104ca0 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 7b 11 80       	push   $0x80117b80
80102dc2:	e8 19 1e 00 00       	call   80104be0 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 7b 11 80       	mov    0x80117bbc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 7b 11 80    	mov    0x80117bc0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 7b 11 80    	mov    %ebx,0x80117bbc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 7b 11 80 01 	movl   $0x1,0x80117bc0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 7b 11 80       	push   $0x80117b80
80102e00:	e8 9b 1e 00 00       	call   80104ca0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 7b 11 80    	mov    0x80117bc8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 7b 11 80       	push   $0x80117b80
80102e1a:	e8 c1 1d 00 00       	call   80104be0 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 7b 11 80 	movl   $0x80117b80,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 7b 11 80 00 	movl   $0x0,0x80117bc0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 3b 17 00 00       	call   80104570 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 7b 11 80 	movl   $0x80117b80,(%esp)
80102e3c:	e8 5f 1e 00 00       	call   80104ca0 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 7b 11 80       	mov    0x80117bb4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 7b 11 80    	pushl  0x80117bc4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 7b 11 80 	pushl  -0x7fee8434(,%ebx,4)
80102e74:	ff 35 c4 7b 11 80    	pushl  0x80117bc4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 f7 1e 00 00       	call   80104d90 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 7b 11 80    	cmp    0x80117bc8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 7b 11 80 00 	movl   $0x0,0x80117bc8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 7b 11 80       	push   $0x80117b80
80102ee8:	e8 83 16 00 00       	call   80104570 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 7b 11 80 	movl   $0x80117b80,(%esp)
80102ef4:	e8 a7 1d 00 00       	call   80104ca0 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 c4 7c 10 80       	push   $0x80107cc4
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 7b 11 80    	mov    0x80117bc8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 7b 11 80       	mov    0x80117bb8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 7b 11 80       	mov    0x80117bbc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 7b 11 80       	push   $0x80117b80
80102f62:	e8 79 1c 00 00       	call   80104be0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 7b 11 80    	mov    0x80117bc8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 7b 11 80 	cmp    %ecx,-0x7fee8434(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 7b 11 80 	mov    %ecx,-0x7fee8434(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 7b 11 80 	movl   $0x80117b80,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 f6 1c 00 00       	jmp    80104ca0 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 7b 11 80 	mov    %ecx,-0x7fee8434(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 7b 11 80    	mov    %edx,0x80117bc8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 7b 11 80       	mov    %eax,0x80117bcc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 d3 7c 10 80       	push   $0x80107cd3
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 e9 7c 10 80       	push   $0x80107ce9
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 c4 0b 00 00       	call   80103bc0 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 bd 0b 00 00       	call   80103bc0 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 04 7d 10 80       	push   $0x80107d04
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 49 30 00 00       	call   80106060 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 34 0b 00 00       	call   80103b50 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 d1 0e 00 00       	call   80103f00 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 f1 40 00 00       	call   80107130 <switchkvm>
  seginit();
8010303f:	e8 5c 40 00 00       	call   801070a0 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 c8 ae 11 80       	push   $0x8011aec8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 96 45 00 00       	call   80107610 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 17 40 00 00       	call   801070a0 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 c3 32 00 00       	call   80106360 <uartinit>
  pinit();         // process table
8010309d:	e8 8e 0a 00 00       	call   80103b30 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 39 2f 00 00       	call   80105fe0 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c b4 10 80       	push   $0x8010b48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 c3 1c 00 00       	call   80104d90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 82 11 80 b0 	imul   $0xb0,0x80118200,%eax
801030d7:	00 00 00 
801030da:	05 80 7c 11 80       	add    $0x80117c80,%eax
801030df:	3d 80 7c 11 80       	cmp    $0x80117c80,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 7c 11 80       	mov    $0x80117c80,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 82 11 80 b0 	imul   $0xb0,0x80118200,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 7c 11 80       	add    $0x80117c80,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 42 0a 00 00       	call   80103b50 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010312b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 99 0a 00 00       	call   80103c10 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 18 7d 10 80       	push   $0x80107d18
801031b3:	56                   	push   %esi
801031b4:	e8 87 1b 00 00       	call   80104d40 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 1d 7d 10 80       	push   $0x80107d1d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 c8 1a 00 00       	call   80104d40 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 7b 11 80       	mov    %eax,0x80117b7c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 7c 11 80    	mov    %cl,0x80117c60
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 82 11 80    	mov    0x80118200,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 82 11 80    	mov    %ecx,0x80118200
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 7c 11 80    	mov    %bl,-0x7fee8380(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 22 7d 10 80       	push   $0x80107d22
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 3c 7d 10 80       	push   $0x80107d3c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 5b 7d 10 80       	push   $0x80107d5b
8010347c:	50                   	push   %eax
8010347d:	e8 de 15 00 00       	call   80104a60 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 b8 16 00 00       	call   80104be0 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 28 10 00 00       	call   80104570 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 33 17 00 00       	jmp    80104ca0 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 e7 0f 00 00       	call   80104570 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 07 17 00 00       	call   80104ca0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 1a 16 00 00       	call   80104be0 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 d3 05 00 00       	call   80103be0 <myproc>
8010360d:	8b 48 38             	mov    0x38(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 53 0f 00 00       	call   80104570 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 7a 0d 00 00       	call   801043a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 4f 16 00 00       	call   80104ca0 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 d1 0e 00 00       	call   80104570 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 f9 15 00 00       	call   80104ca0 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 11 15 00 00       	call   80104be0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 f3 04 00 00       	call   80103be0 <myproc>
801036ed:	8b 48 38             	mov    0x38(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 9e 0c 00 00       	call   801043a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 05 0e 00 00       	call   80104570 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 2d 15 00 00       	call   80104ca0 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 12 15 00 00       	call   80104ca0 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 74 82 11 80       	mov    $0x80118274,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 40 82 11 80       	push   $0x80118240
801037b1:	e8 2a 14 00 00       	call   80104be0 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801037c6:	81 fb 74 a6 11 80    	cmp    $0x8011a674,%ebx
801037cc:	0f 84 7e 00 00 00    	je     80103850 <allocproc+0xb0>
    if(p->state == UNUSED)
801037d2:	8b 43 20             	mov    0x20(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d9:	a1 18 b0 10 80       	mov    0x8010b018,%eax
  p->prio = 10;

  release(&ptable.lock);
801037de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037e1:	c7 43 20 01 00 00 00 	movl   $0x1,0x20(%ebx)
  p->prio = 10;
801037e8:	c7 43 10 0a 00 00 00 	movl   $0xa,0x10(%ebx)
  p->pid = nextpid++;
801037ef:	89 43 24             	mov    %eax,0x24(%ebx)
801037f2:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037f5:	68 40 82 11 80       	push   $0x80118240
  p->pid = nextpid++;
801037fa:	89 15 18 b0 10 80    	mov    %edx,0x8010b018
  release(&ptable.lock);
80103800:	e8 9b 14 00 00       	call   80104ca0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103805:	e8 36 ee ff ff       	call   80102640 <kalloc>
8010380a:	83 c4 10             	add    $0x10,%esp
8010380d:	89 43 1c             	mov    %eax,0x1c(%ebx)
80103810:	85 c0                	test   %eax,%eax
80103812:	74 55                	je     80103869 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103814:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381a:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010381d:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103822:	89 53 2c             	mov    %edx,0x2c(%ebx)
  *(uint*)sp = (uint)trapret;
80103825:	c7 40 14 cf 5f 10 80 	movl   $0x80105fcf,0x14(%eax)
  p->context = (struct context*)sp;
8010382c:	89 43 30             	mov    %eax,0x30(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010382f:	6a 14                	push   $0x14
80103831:	6a 00                	push   $0x0
80103833:	50                   	push   %eax
80103834:	e8 b7 14 00 00       	call   80104cf0 <memset>
  p->context->eip = (uint)forkret;
80103839:	8b 43 30             	mov    0x30(%ebx),%eax

  return p;
8010383c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010383f:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
80103846:	89 d8                	mov    %ebx,%eax
80103848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384b:	c9                   	leave  
8010384c:	c3                   	ret    
8010384d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 40 82 11 80       	push   $0x80118240
8010385a:	e8 41 14 00 00       	call   80104ca0 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010388a:	68 40 82 11 80       	push   $0x80118240
8010388f:	e8 0c 14 00 00       	call   80104ca0 <release>

  if (first) {
80103894:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 08                	jne    801038a8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a0:	c9                   	leave  
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038a8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038af:	00 00 00 
    iinit(ROOTDEV);
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	6a 01                	push   $0x1
801038b7:	e8 94 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
801038bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038c3:	e8 d8 f3 ff ff       	call   80102ca0 <initlog>
}
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	c9                   	leave  
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <srand>:
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  Q[2] = x + PHI + PHI;
801038da:	8d 90 72 f3 6e 3c    	lea    0x3c6ef372(%eax),%edx
  Q[1] = x + PHI;
801038e0:	8d 88 b9 79 37 9e    	lea    -0x61c88647(%eax),%ecx
  Q[0] = x;
801038e6:	a3 a0 ba 10 80       	mov    %eax,0x8010baa0
  Q[2] = x + PHI + PHI;
801038eb:	89 15 a8 ba 10 80    	mov    %edx,0x8010baa8
  for (i = 3; i < 4096; i++)
801038f1:	ba 03 00 00 00       	mov    $0x3,%edx
  Q[1] = x + PHI;
801038f6:	89 0d a4 ba 10 80    	mov    %ecx,0x8010baa4
  for (i = 3; i < 4096; i++)
801038fc:	eb 10                	jmp    8010390e <srand+0x3e>
801038fe:	66 90                	xchg   %ax,%ax
80103900:	8b 04 95 94 ba 10 80 	mov    -0x7fef456c(,%edx,4),%eax
80103907:	8b 0c 95 98 ba 10 80 	mov    -0x7fef4568(,%edx,4),%ecx
    Q[i] = Q[i - 3] ^ Q[i - 2] ^ PHI ^ i;
8010390e:	31 c8                	xor    %ecx,%eax
80103910:	31 d0                	xor    %edx,%eax
80103912:	35 b9 79 37 9e       	xor    $0x9e3779b9,%eax
80103917:	89 04 95 a0 ba 10 80 	mov    %eax,-0x7fef4560(,%edx,4)
  for (i = 3; i < 4096; i++)
8010391e:	83 c2 01             	add    $0x1,%edx
80103921:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
80103927:	75 d7                	jne    80103900 <srand+0x30>
}
80103929:	5d                   	pop    %ebp
8010392a:	c3                   	ret    
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop

80103930 <rand>:
{
80103930:	f3 0f 1e fb          	endbr32 
  i = (i + 1) & 4095;
80103934:	a1 14 b0 10 80       	mov    0x8010b014,%eax
  t = a * Q[i] + c;
80103939:	8b 0d 1c b0 10 80    	mov    0x8010b01c,%ecx
{
8010393f:	55                   	push   %ebp
80103940:	89 e5                	mov    %esp,%ebp
80103942:	56                   	push   %esi
  i = (i + 1) & 4095;
80103943:	8d 70 01             	lea    0x1(%eax),%esi
  t = a * Q[i] + c;
80103946:	b8 5e 49 00 00       	mov    $0x495e,%eax
  i = (i + 1) & 4095;
8010394b:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
{
80103951:	53                   	push   %ebx
  t = a * Q[i] + c;
80103952:	31 db                	xor    %ebx,%ebx
80103954:	f7 24 b5 a0 ba 10 80 	mull   -0x7fef4560(,%esi,4)
  i = (i + 1) & 4095;
8010395b:	89 35 14 b0 10 80    	mov    %esi,0x8010b014
  t = a * Q[i] + c;
80103961:	01 c8                	add    %ecx,%eax
80103963:	11 da                	adc    %ebx,%edx
  x = t + c;
80103965:	01 d0                	add    %edx,%eax
  if (x < c) {
80103967:	72 1f                	jb     80103988 <rand+0x58>
  c = (t >> 32);
80103969:	89 15 1c b0 10 80    	mov    %edx,0x8010b01c
  return (Q[i] = r - x);
8010396f:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
}
80103974:	5b                   	pop    %ebx
  return (Q[i] = r - x);
80103975:	29 c2                	sub    %eax,%edx
80103977:	89 14 b5 a0 ba 10 80 	mov    %edx,-0x7fef4560(,%esi,4)
8010397e:	89 d0                	mov    %edx,%eax
}
80103980:	5e                   	pop    %esi
80103981:	5d                   	pop    %ebp
80103982:	c3                   	ret    
80103983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103987:	90                   	nop
    c++;
80103988:	8d 52 01             	lea    0x1(%edx),%edx
    x++;
8010398b:	83 c0 01             	add    $0x1,%eax
    c++;
8010398e:	89 15 1c b0 10 80    	mov    %edx,0x8010b01c
80103994:	eb d9                	jmp    8010396f <rand+0x3f>
80103996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399d:	8d 76 00             	lea    0x0(%esi),%esi

801039a0 <uptime>:
{
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	53                   	push   %ebx
801039a8:	83 ec 10             	sub    $0x10,%esp
  acquire(&tickslock);
801039ab:	68 80 a6 11 80       	push   $0x8011a680
801039b0:	e8 2b 12 00 00       	call   80104be0 <acquire>
  xticks = ticks;
801039b5:	8b 1d c0 ae 11 80    	mov    0x8011aec0,%ebx
  release(&tickslock);
801039bb:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
801039c2:	e8 d9 12 00 00       	call   80104ca0 <release>
}
801039c7:	89 d8                	mov    %ebx,%eax
801039c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039cc:	c9                   	leave  
801039cd:	c3                   	ret    
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <random>:
{
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	55                   	push   %ebp
801039d5:	b8 01 00 00 00       	mov    $0x1,%eax
801039da:	89 e5                	mov    %esp,%ebp
801039dc:	57                   	push   %edi
801039dd:	56                   	push   %esi
801039de:	53                   	push   %ebx
801039df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (max <= 0)
801039e2:	85 db                	test   %ebx,%ebx
801039e4:	0f 8e 9d 00 00 00    	jle    80103a87 <random+0xb7>
  b = (((z1 << 6) ^ z1) >> 13);
801039ea:	8b 35 10 b0 10 80    	mov    0x8010b010,%esi
  b = (((z3 << 13) ^ z3) >> 21);
801039f0:	8b 15 08 b0 10 80    	mov    0x8010b008,%edx
  b = (((z1 << 6) ^ z1) >> 13);
801039f6:	89 f1                	mov    %esi,%ecx
801039f8:	c1 e1 06             	shl    $0x6,%ecx
801039fb:	31 f1                	xor    %esi,%ecx
  z1 = (((z1 & 4294967294) << 18) ^ b);
801039fd:	c1 e6 12             	shl    $0x12,%esi
80103a00:	81 e6 00 00 f8 ff    	and    $0xfff80000,%esi
  b = (((z1 << 6) ^ z1) >> 13);
80103a06:	c1 f9 0d             	sar    $0xd,%ecx
  z1 = (((z1 & 4294967294) << 18) ^ b);
80103a09:	31 f1                	xor    %esi,%ecx
  b = (((z2 << 2) ^ z2) >> 27);
80103a0b:	8b 35 0c b0 10 80    	mov    0x8010b00c,%esi
  z1 = (((z1 & 4294967294) << 18) ^ b);
80103a11:	89 0d 10 b0 10 80    	mov    %ecx,0x8010b010
  b = (((z2 << 2) ^ z2) >> 27);
80103a17:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
80103a1e:	31 f0                	xor    %esi,%eax
  z2 = (((z2 & 4294967288) << 2) ^ b);
80103a20:	c1 e6 02             	shl    $0x2,%esi
80103a23:	83 e6 e0             	and    $0xffffffe0,%esi
  b = (((z2 << 2) ^ z2) >> 27);
80103a26:	c1 f8 1b             	sar    $0x1b,%eax
  z2 = (((z2 & 4294967288) << 2) ^ b);
80103a29:	31 f0                	xor    %esi,%eax
80103a2b:	89 c7                	mov    %eax,%edi
80103a2d:	a3 0c b0 10 80       	mov    %eax,0x8010b00c
  b = (((z3 << 13) ^ z3) >> 21);
80103a32:	89 d0                	mov    %edx,%eax
80103a34:	c1 e0 0d             	shl    $0xd,%eax
80103a37:	31 d0                	xor    %edx,%eax
  z3 = (((z3 & 4294967280) << 7) ^ b);
80103a39:	c1 e2 07             	shl    $0x7,%edx
80103a3c:	81 e2 00 f8 ff ff    	and    $0xfffff800,%edx
  b = (((z3 << 13) ^ z3) >> 21);
80103a42:	c1 f8 15             	sar    $0x15,%eax
  z3 = (((z3 & 4294967280) << 7) ^ b);
80103a45:	31 d0                	xor    %edx,%eax
  b = (((z4 << 3) ^ z4) >> 12);
80103a47:	8b 15 04 b0 10 80    	mov    0x8010b004,%edx
  z3 = (((z3 & 4294967280) << 7) ^ b);
80103a4d:	89 c6                	mov    %eax,%esi
80103a4f:	a3 08 b0 10 80       	mov    %eax,0x8010b008
  b = (((z4 << 3) ^ z4) >> 12);
80103a54:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
80103a5b:	31 d0                	xor    %edx,%eax
  z4 = (((z4 & 4294967168) << 13) ^ b);
80103a5d:	c1 e2 0d             	shl    $0xd,%edx
  b = (((z4 << 3) ^ z4) >> 12);
80103a60:	c1 f8 0c             	sar    $0xc,%eax
  z4 = (((z4 & 4294967168) << 13) ^ b);
80103a63:	81 e2 00 00 f0 ff    	and    $0xfff00000,%edx
80103a69:	31 c2                	xor    %eax,%edx
  int rand = ((z1 ^ z2 ^ z3 ^ z4)) % max;
80103a6b:	89 c8                	mov    %ecx,%eax
80103a6d:	31 f8                	xor    %edi,%eax
  z4 = (((z4 & 4294967168) << 13) ^ b);
80103a6f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  int rand = ((z1 ^ z2 ^ z3 ^ z4)) % max;
80103a75:	31 f0                	xor    %esi,%eax
80103a77:	31 d0                	xor    %edx,%eax
80103a79:	99                   	cltd   
80103a7a:	f7 fb                	idiv   %ebx
80103a7c:	89 d1                	mov    %edx,%ecx
80103a7e:	89 d0                	mov    %edx,%eax
80103a80:	c1 f9 1f             	sar    $0x1f,%ecx
80103a83:	31 c8                	xor    %ecx,%eax
80103a85:	29 c8                	sub    %ecx,%eax
}
80103a87:	5b                   	pop    %ebx
80103a88:	5e                   	pop    %esi
80103a89:	5f                   	pop    %edi
80103a8a:	5d                   	pop    %ebp
80103a8b:	c3                   	ret    
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a90 <return_index>:
int return_index(int prio){
80103a90:	f3 0f 1e fb          	endbr32 
80103a94:	55                   	push   %ebp
80103a95:	89 e5                	mov    %esp,%ebp
80103a97:	8b 55 08             	mov    0x8(%ebp),%edx
  if (prio == 4){
80103a9a:	83 fa 04             	cmp    $0x4,%edx
80103a9d:	74 41                	je     80103ae0 <return_index+0x50>
  else if (prio == 5){
80103a9f:	83 fa 05             	cmp    $0x5,%edx
80103aa2:	74 0c                	je     80103ab0 <return_index+0x20>
    for(int i = 0 ; i < 1000 ; i++){
80103aa4:	31 c0                	xor    %eax,%eax
  else if (prio == 6){
80103aa6:	83 fa 06             	cmp    $0x6,%edx
80103aa9:	74 55                	je     80103b00 <return_index+0x70>
}
80103aab:	5d                   	pop    %ebp
80103aac:	c3                   	ret    
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
      if(proc_loto_q[i] != 0) {
80103ab0:	a1 60 b7 10 80       	mov    0x8010b760,%eax
80103ab5:	85 c0                	test   %eax,%eax
80103ab7:	75 67                	jne    80103b20 <return_index+0x90>
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int i = 0 ; i < 1000 ; i++){
80103ac0:	83 c0 01             	add    $0x1,%eax
      if(proc_loto_q[i] != 0) {
80103ac3:	8b 0c 85 60 b7 10 80 	mov    -0x7fef48a0(,%eax,4),%ecx
80103aca:	85 c9                	test   %ecx,%ecx
80103acc:	75 dd                	jne    80103aab <return_index+0x1b>
    for(int i = 0 ; i < 1000 ; i++){
80103ace:	83 c0 01             	add    $0x1,%eax
      if(proc_loto_q[i] != 0) {
80103ad1:	8b 0c 85 60 b7 10 80 	mov    -0x7fef48a0(,%eax,4),%ecx
80103ad8:	85 c9                	test   %ecx,%ecx
80103ada:	74 e4                	je     80103ac0 <return_index+0x30>
80103adc:	eb cd                	jmp    80103aab <return_index+0x1b>
80103ade:	66 90                	xchg   %ax,%ax
      if(proc_rr_q[i] != 0) {
80103ae0:	a1 00 b9 10 80       	mov    0x8010b900,%eax
80103ae5:	85 c0                	test   %eax,%eax
80103ae7:	75 37                	jne    80103b20 <return_index+0x90>
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int i = 0 ; i < 1000 ; i++){
80103af0:	83 c0 01             	add    $0x1,%eax
      if(proc_rr_q[i] != 0) {
80103af3:	8b 14 85 00 b9 10 80 	mov    -0x7fef4700(,%eax,4),%edx
80103afa:	85 d2                	test   %edx,%edx
80103afc:	74 f2                	je     80103af0 <return_index+0x60>
}
80103afe:	5d                   	pop    %ebp
80103aff:	c3                   	ret    
      if(proc_fcfs_q[i] != 0) {
80103b00:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80103b05:	85 c0                	test   %eax,%eax
80103b07:	75 17                	jne    80103b20 <return_index+0x90>
80103b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int i = 0 ; i < 1000 ; i++){
80103b10:	83 c0 01             	add    $0x1,%eax
      if(proc_fcfs_q[i] != 0) {
80103b13:	8b 14 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%edx
80103b1a:	85 d2                	test   %edx,%edx
80103b1c:	74 f2                	je     80103b10 <return_index+0x80>
}
80103b1e:	5d                   	pop    %ebp
80103b1f:	c3                   	ret    
    for(int i = 0 ; i < 1000 ; i++){
80103b20:	31 c0                	xor    %eax,%eax
}
80103b22:	5d                   	pop    %ebp
80103b23:	c3                   	ret    
80103b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <pinit>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b3a:	68 60 7d 10 80       	push   $0x80107d60
80103b3f:	68 40 82 11 80       	push   $0x80118240
80103b44:	e8 17 0f 00 00       	call   80104a60 <initlock>
}
80103b49:	83 c4 10             	add    $0x10,%esp
80103b4c:	c9                   	leave  
80103b4d:	c3                   	ret    
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <mycpu>:
{
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
80103b55:	89 e5                	mov    %esp,%ebp
80103b57:	56                   	push   %esi
80103b58:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b59:	9c                   	pushf  
80103b5a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b5b:	f6 c4 02             	test   $0x2,%ah
80103b5e:	75 4a                	jne    80103baa <mycpu+0x5a>
  apicid = lapicid();
80103b60:	e8 4b ed ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b65:	8b 35 00 82 11 80    	mov    0x80118200,%esi
  apicid = lapicid();
80103b6b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103b6d:	85 f6                	test   %esi,%esi
80103b6f:	7e 2c                	jle    80103b9d <mycpu+0x4d>
80103b71:	31 d2                	xor    %edx,%edx
80103b73:	eb 0a                	jmp    80103b7f <mycpu+0x2f>
80103b75:	8d 76 00             	lea    0x0(%esi),%esi
80103b78:	83 c2 01             	add    $0x1,%edx
80103b7b:	39 f2                	cmp    %esi,%edx
80103b7d:	74 1e                	je     80103b9d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b7f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b85:	0f b6 81 80 7c 11 80 	movzbl -0x7fee8380(%ecx),%eax
80103b8c:	39 d8                	cmp    %ebx,%eax
80103b8e:	75 e8                	jne    80103b78 <mycpu+0x28>
}
80103b90:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b93:	8d 81 80 7c 11 80    	lea    -0x7fee8380(%ecx),%eax
}
80103b99:	5b                   	pop    %ebx
80103b9a:	5e                   	pop    %esi
80103b9b:	5d                   	pop    %ebp
80103b9c:	c3                   	ret    
  panic("unknown apicid\n");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 67 7d 10 80       	push   $0x80107d67
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 58 7e 10 80       	push   $0x80107e58
80103bb2:	e8 d9 c7 ff ff       	call   80100390 <panic>
80103bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbe:	66 90                	xchg   %ax,%ax

80103bc0 <cpuid>:
cpuid() {
80103bc0:	f3 0f 1e fb          	endbr32 
80103bc4:	55                   	push   %ebp
80103bc5:	89 e5                	mov    %esp,%ebp
80103bc7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103bca:	e8 81 ff ff ff       	call   80103b50 <mycpu>
}
80103bcf:	c9                   	leave  
  return mycpu()-cpus;
80103bd0:	2d 80 7c 11 80       	sub    $0x80117c80,%eax
80103bd5:	c1 f8 04             	sar    $0x4,%eax
80103bd8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bde:	c3                   	ret    
80103bdf:	90                   	nop

80103be0 <myproc>:
myproc(void) {
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	53                   	push   %ebx
80103be8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103beb:	e8 f0 0e 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103bf0:	e8 5b ff ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103bf5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bfb:	e8 30 0f 00 00       	call   80104b30 <popcli>
}
80103c00:	83 c4 04             	add    $0x4,%esp
80103c03:	89 d8                	mov    %ebx,%eax
80103c05:	5b                   	pop    %ebx
80103c06:	5d                   	pop    %ebp
80103c07:	c3                   	ret    
80103c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c0f:	90                   	nop

80103c10 <userinit>:
{
80103c10:	f3 0f 1e fb          	endbr32 
80103c14:	55                   	push   %ebp
80103c15:	89 e5                	mov    %esp,%ebp
80103c17:	53                   	push   %ebx
80103c18:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c1b:	e8 80 fb ff ff       	call   801037a0 <allocproc>
80103c20:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c22:	a3 90 ba 10 80       	mov    %eax,0x8010ba90
  if((p->pgdir = setupkvm()) == 0)
80103c27:	e8 64 39 00 00       	call   80107590 <setupkvm>
80103c2c:	89 43 18             	mov    %eax,0x18(%ebx)
80103c2f:	85 c0                	test   %eax,%eax
80103c31:	0f 84 c1 00 00 00    	je     80103cf8 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c37:	83 ec 04             	sub    $0x4,%esp
80103c3a:	68 2c 00 00 00       	push   $0x2c
80103c3f:	68 60 b4 10 80       	push   $0x8010b460
80103c44:	50                   	push   %eax
80103c45:	e8 16 36 00 00       	call   80107260 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c4a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c4d:	c7 43 14 00 10 00 00 	movl   $0x1000,0x14(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c54:	6a 4c                	push   $0x4c
80103c56:	6a 00                	push   $0x0
80103c58:	ff 73 2c             	pushl  0x2c(%ebx)
80103c5b:	e8 90 10 00 00       	call   80104cf0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c60:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103c63:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c68:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c6b:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c70:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c74:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103c77:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c7b:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103c7e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c82:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c86:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103c89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c8d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c91:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103c94:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c9b:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103c9e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ca5:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103ca8:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103caf:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103cb5:	6a 10                	push   $0x10
80103cb7:	68 90 7d 10 80       	push   $0x80107d90
80103cbc:	50                   	push   %eax
80103cbd:	e8 ee 11 00 00       	call   80104eb0 <safestrcpy>
  p->cwd = namei("/");
80103cc2:	c7 04 24 99 7d 10 80 	movl   $0x80107d99,(%esp)
80103cc9:	e8 72 e3 ff ff       	call   80102040 <namei>
80103cce:	89 43 7c             	mov    %eax,0x7c(%ebx)
  acquire(&ptable.lock);
80103cd1:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103cd8:	e8 03 0f 00 00       	call   80104be0 <acquire>
  p->state = RUNNABLE;
80103cdd:	c7 43 20 03 00 00 00 	movl   $0x3,0x20(%ebx)
  release(&ptable.lock);
80103ce4:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103ceb:	e8 b0 0f 00 00       	call   80104ca0 <release>
}
80103cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf3:	83 c4 10             	add    $0x10,%esp
80103cf6:	c9                   	leave  
80103cf7:	c3                   	ret    
    panic("userinit: out of memory?");
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	68 77 7d 10 80       	push   $0x80107d77
80103d00:	e8 8b c6 ff ff       	call   80100390 <panic>
80103d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d10 <growproc>:
{
80103d10:	f3 0f 1e fb          	endbr32 
80103d14:	55                   	push   %ebp
80103d15:	89 e5                	mov    %esp,%ebp
80103d17:	56                   	push   %esi
80103d18:	53                   	push   %ebx
80103d19:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d1c:	e8 bf 0d 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103d21:	e8 2a fe ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103d26:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d2c:	e8 ff 0d 00 00       	call   80104b30 <popcli>
  sz = curproc->sz;
80103d31:	8b 43 14             	mov    0x14(%ebx),%eax
  if(n > 0){
80103d34:	85 f6                	test   %esi,%esi
80103d36:	7f 20                	jg     80103d58 <growproc+0x48>
  } else if(n < 0){
80103d38:	75 3e                	jne    80103d78 <growproc+0x68>
  switchuvm(curproc);
80103d3a:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d3d:	89 43 14             	mov    %eax,0x14(%ebx)
  switchuvm(curproc);
80103d40:	53                   	push   %ebx
80103d41:	e8 0a 34 00 00       	call   80107150 <switchuvm>
  return 0;
80103d46:	83 c4 10             	add    $0x10,%esp
80103d49:	31 c0                	xor    %eax,%eax
}
80103d4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d4e:	5b                   	pop    %ebx
80103d4f:	5e                   	pop    %esi
80103d50:	5d                   	pop    %ebp
80103d51:	c3                   	ret    
80103d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d58:	83 ec 04             	sub    $0x4,%esp
80103d5b:	01 c6                	add    %eax,%esi
80103d5d:	56                   	push   %esi
80103d5e:	50                   	push   %eax
80103d5f:	ff 73 18             	pushl  0x18(%ebx)
80103d62:	e8 49 36 00 00       	call   801073b0 <allocuvm>
80103d67:	83 c4 10             	add    $0x10,%esp
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	75 cc                	jne    80103d3a <growproc+0x2a>
      return -1;
80103d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d73:	eb d6                	jmp    80103d4b <growproc+0x3b>
80103d75:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d78:	83 ec 04             	sub    $0x4,%esp
80103d7b:	01 c6                	add    %eax,%esi
80103d7d:	56                   	push   %esi
80103d7e:	50                   	push   %eax
80103d7f:	ff 73 18             	pushl  0x18(%ebx)
80103d82:	e8 59 37 00 00       	call   801074e0 <deallocuvm>
80103d87:	83 c4 10             	add    $0x10,%esp
80103d8a:	85 c0                	test   %eax,%eax
80103d8c:	75 ac                	jne    80103d3a <growproc+0x2a>
80103d8e:	eb de                	jmp    80103d6e <growproc+0x5e>

80103d90 <fork>:
{
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	57                   	push   %edi
80103d98:	56                   	push   %esi
80103d99:	53                   	push   %ebx
80103d9a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d9d:	e8 3e 0d 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103da2:	e8 a9 fd ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103da7:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103dad:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  popcli();
80103db0:	e8 7b 0d 00 00       	call   80104b30 <popcli>
  if((np = allocproc()) == 0){
80103db5:	e8 e6 f9 ff ff       	call   801037a0 <allocproc>
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	0f 84 07 01 00 00    	je     80103ec9 <fork+0x139>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dc2:	83 ec 08             	sub    $0x8,%esp
80103dc5:	ff 77 14             	pushl  0x14(%edi)
80103dc8:	89 c3                	mov    %eax,%ebx
80103dca:	ff 77 18             	pushl  0x18(%edi)
80103dcd:	e8 8e 38 00 00       	call   80107660 <copyuvm>
80103dd2:	83 c4 10             	add    $0x10,%esp
80103dd5:	89 43 18             	mov    %eax,0x18(%ebx)
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	0f 84 f0 00 00 00    	je     80103ed0 <fork+0x140>
  acquire(&tickslock);
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	68 80 a6 11 80       	push   $0x8011a680
80103de8:	e8 f3 0d 00 00       	call   80104be0 <acquire>
  release(&tickslock);
80103ded:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
  xticks = ticks;
80103df4:	8b 35 c0 ae 11 80    	mov    0x8011aec0,%esi
  release(&tickslock);
80103dfa:	e8 a1 0e 00 00       	call   80104ca0 <release>
  np->sz = curproc->sz;
80103dff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  np->arrival = 0;
80103e02:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  np->ticks = uptime();
80103e08:	89 73 04             	mov    %esi,0x4(%ebx)
  np->sz = curproc->sz;
80103e0b:	8b 47 14             	mov    0x14(%edi),%eax
  np->parent = curproc;
80103e0e:	89 7b 28             	mov    %edi,0x28(%ebx)
  np->prio = 10;
80103e11:	c7 43 10 0a 00 00 00 	movl   $0xa,0x10(%ebx)
  np->sz = curproc->sz;
80103e18:	89 43 14             	mov    %eax,0x14(%ebx)
    np->tickets = random(np->pid);
80103e1b:	58                   	pop    %eax
80103e1c:	ff 73 24             	pushl  0x24(%ebx)
80103e1f:	e8 ac fb ff ff       	call   801039d0 <random>
  *np->tf = *curproc->tf;
80103e24:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->tf->eax = 0;
80103e29:	83 c4 10             	add    $0x10,%esp
    np->tickets = random(np->pid);
80103e2c:	89 43 08             	mov    %eax,0x8(%ebx)
  *np->tf = *curproc->tf;
80103e2f:	8b 77 2c             	mov    0x2c(%edi),%esi
80103e32:	8b 7b 2c             	mov    0x2c(%ebx),%edi
80103e35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e37:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e39:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103e3c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e47:	90                   	nop
    if(curproc->ofile[i])
80103e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e4b:	8b 44 b0 3c          	mov    0x3c(%eax,%esi,4),%eax
80103e4f:	85 c0                	test   %eax,%eax
80103e51:	74 10                	je     80103e63 <fork+0xd3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	50                   	push   %eax
80103e57:	e8 24 d0 ff ff       	call   80100e80 <filedup>
80103e5c:	83 c4 10             	add    $0x10,%esp
80103e5f:	89 44 b3 3c          	mov    %eax,0x3c(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e63:	83 c6 01             	add    $0x1,%esi
80103e66:	83 fe 10             	cmp    $0x10,%esi
80103e69:	75 dd                	jne    80103e48 <fork+0xb8>
  np->cwd = idup(curproc->cwd);
80103e6b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e6e:	83 ec 0c             	sub    $0xc,%esp
80103e71:	ff 77 7c             	pushl  0x7c(%edi)
80103e74:	e8 c7 d8 ff ff       	call   80101740 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e79:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e7c:	89 43 7c             	mov    %eax,0x7c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e7f:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80103e85:	6a 10                	push   $0x10
80103e87:	50                   	push   %eax
80103e88:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103e8e:	50                   	push   %eax
80103e8f:	e8 1c 10 00 00       	call   80104eb0 <safestrcpy>
  pid = np->pid;
80103e94:	8b 73 24             	mov    0x24(%ebx),%esi
  acquire(&ptable.lock);
80103e97:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103e9e:	e8 3d 0d 00 00       	call   80104be0 <acquire>
  np->proc_index = np->pid;
80103ea3:	8b 43 24             	mov    0x24(%ebx),%eax
  np->state = RUNNABLE;
80103ea6:	c7 43 20 03 00 00 00 	movl   $0x3,0x20(%ebx)
  np->proc_index = np->pid;
80103ead:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&ptable.lock);
80103eb0:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103eb7:	e8 e4 0d 00 00       	call   80104ca0 <release>
  return pid;
80103ebc:	83 c4 10             	add    $0x10,%esp
}
80103ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec2:	89 f0                	mov    %esi,%eax
80103ec4:	5b                   	pop    %ebx
80103ec5:	5e                   	pop    %esi
80103ec6:	5f                   	pop    %edi
80103ec7:	5d                   	pop    %ebp
80103ec8:	c3                   	ret    
    return -1;
80103ec9:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103ece:	eb ef                	jmp    80103ebf <fork+0x12f>
    kfree(np->kstack);
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	ff 73 1c             	pushl  0x1c(%ebx)
    return -1;
80103ed6:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103edb:	e8 a0 e5 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103ee0:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    return -1;
80103ee7:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103eea:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    return -1;
80103ef1:	eb cc                	jmp    80103ebf <fork+0x12f>
80103ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f00 <scheduler>:
{
80103f00:	f3 0f 1e fb          	endbr32 
80103f04:	55                   	push   %ebp
80103f05:	89 e5                	mov    %esp,%ebp
80103f07:	57                   	push   %edi
80103f08:	56                   	push   %esi
80103f09:	53                   	push   %ebx
80103f0a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103f0d:	e8 3e fc ff ff       	call   80103b50 <mycpu>
  c->proc = 0;
80103f12:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f19:	00 00 00 
  struct cpu *c = mycpu();
80103f1c:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103f1e:	8d 40 04             	lea    0x4(%eax),%eax
80103f21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103f24:	fb                   	sti    
    acquire(&ptable.lock);
80103f25:	83 ec 0c             	sub    $0xc,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f28:	bf 74 82 11 80       	mov    $0x80118274,%edi
    acquire(&ptable.lock);
80103f2d:	68 40 82 11 80       	push   $0x80118240
80103f32:	e8 a9 0c 00 00       	call   80104be0 <acquire>
80103f37:	83 c4 10             	add    $0x10,%esp
80103f3a:	eb 16                	jmp    80103f52 <scheduler+0x52>
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f40:	81 c7 90 00 00 00    	add    $0x90,%edi
80103f46:	81 ff 74 a6 11 80    	cmp    $0x8011a674,%edi
80103f4c:	0f 83 8c 00 00 00    	jae    80103fde <scheduler+0xde>
        if(p->state != RUNNABLE)
80103f52:	83 7f 20 03          	cmpl   $0x3,0x20(%edi)
80103f56:	75 e8                	jne    80103f40 <scheduler+0x40>
        if(p->ticks > CYCLE_AGE_LIMIT && p->prio > 4)
80103f58:	81 7f 04 e8 03 00 00 	cmpl   $0x3e8,0x4(%edi)
80103f5f:	76 0e                	jbe    80103f6f <scheduler+0x6f>
80103f61:	8b 47 10             	mov    0x10(%edi),%eax
80103f64:	83 f8 04             	cmp    $0x4,%eax
80103f67:	7e 06                	jle    80103f6f <scheduler+0x6f>
          p->prio --;
80103f69:	83 e8 01             	sub    $0x1,%eax
80103f6c:	89 47 10             	mov    %eax,0x10(%edi)
        for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103f6f:	b8 74 82 11 80       	mov    $0x80118274,%eax
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if(p1->state != RUNNABLE)
80103f78:	83 78 20 03          	cmpl   $0x3,0x20(%eax)
80103f7c:	75 09                	jne    80103f87 <scheduler+0x87>
          if(highP->prio > p1->prio)   //larger value, lower priority
80103f7e:	8b 48 10             	mov    0x10(%eax),%ecx
80103f81:	39 4f 10             	cmp    %ecx,0x10(%edi)
80103f84:	0f 4f f8             	cmovg  %eax,%edi
        for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103f87:	05 90 00 00 00       	add    $0x90,%eax
80103f8c:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
80103f91:	75 e5                	jne    80103f78 <scheduler+0x78>
        switchuvm(p);
80103f93:	83 ec 0c             	sub    $0xc,%esp
        p->ticks++;
80103f96:	83 47 04 01          	addl   $0x1,0x4(%edi)
        c->proc = p;
80103f9a:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
80103fa0:	57                   	push   %edi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa1:	81 c7 90 00 00 00    	add    $0x90,%edi
        switchuvm(p);
80103fa7:	e8 a4 31 00 00       	call   80107150 <switchuvm>
        p->state = RUNNING;
80103fac:	c7 47 90 04 00 00 00 	movl   $0x4,-0x70(%edi)
        swtch(&(c->scheduler), p->context);
80103fb3:	58                   	pop    %eax
80103fb4:	5a                   	pop    %edx
80103fb5:	ff 77 a0             	pushl  -0x60(%edi)
80103fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
80103fbb:	e8 53 0f 00 00       	call   80104f13 <swtch>
        switchkvm();
80103fc0:	e8 6b 31 00 00       	call   80107130 <switchkvm>
        c->proc = 0;
80103fc5:	83 c4 10             	add    $0x10,%esp
80103fc8:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103fcf:	00 00 00 
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd2:	81 ff 74 a6 11 80    	cmp    $0x8011a674,%edi
80103fd8:	0f 82 74 ff ff ff    	jb     80103f52 <scheduler+0x52>
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fde:	bf 74 82 11 80       	mov    $0x80118274,%edi
80103fe3:	eb 15                	jmp    80103ffa <scheduler+0xfa>
80103fe5:	8d 76 00             	lea    0x0(%esi),%esi
80103fe8:	81 c7 90 00 00 00    	add    $0x90,%edi
80103fee:	81 ff 74 a6 11 80    	cmp    $0x8011a674,%edi
80103ff4:	0f 83 a3 00 00 00    	jae    8010409d <scheduler+0x19d>
        if(p->state != RUNNABLE || p->tickets == 0)
80103ffa:	83 7f 20 03          	cmpl   $0x3,0x20(%edi)
80103ffe:	75 e8                	jne    80103fe8 <scheduler+0xe8>
80104000:	8b 47 08             	mov    0x8(%edi),%eax
80104003:	85 c0                	test   %eax,%eax
80104005:	74 e1                	je     80103fe8 <scheduler+0xe8>
        if(p->ticks > CYCLE_AGE_LIMIT && p->prio > 4)
80104007:	81 7f 04 e8 03 00 00 	cmpl   $0x3e8,0x4(%edi)
8010400e:	76 0e                	jbe    8010401e <scheduler+0x11e>
80104010:	8b 47 10             	mov    0x10(%edi),%eax
80104013:	83 f8 04             	cmp    $0x4,%eax
80104016:	7e 06                	jle    8010401e <scheduler+0x11e>
          p->prio --;
80104018:	83 e8 01             	sub    $0x1,%eax
8010401b:	89 47 10             	mov    %eax,0x10(%edi)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401e:	be 74 82 11 80       	mov    $0x80118274,%esi
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
          rand_ticket = random(300);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	68 2c 01 00 00       	push   $0x12c
80104030:	e8 9b f9 ff ff       	call   801039d0 <random>
          if(p1->state != RUNNABLE || p1->tickets != rand_ticket)
80104035:	83 c4 10             	add    $0x10,%esp
80104038:	83 7e 20 03          	cmpl   $0x3,0x20(%esi)
8010403c:	75 06                	jne    80104044 <scheduler+0x144>
8010403e:	39 46 08             	cmp    %eax,0x8(%esi)
80104041:	0f 44 fe             	cmove  %esi,%edi
        for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80104044:	81 c6 90 00 00 00    	add    $0x90,%esi
8010404a:	81 fe 74 a6 11 80    	cmp    $0x8011a674,%esi
80104050:	75 d6                	jne    80104028 <scheduler+0x128>
        switchuvm(p);
80104052:	83 ec 0c             	sub    $0xc,%esp
        p->ticks++;
80104055:	83 47 04 01          	addl   $0x1,0x4(%edi)
        c->proc = p;
80104059:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
8010405f:	57                   	push   %edi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104060:	81 c7 90 00 00 00    	add    $0x90,%edi
        switchuvm(p);
80104066:	e8 e5 30 00 00       	call   80107150 <switchuvm>
        p->state = RUNNING;
8010406b:	c7 47 90 04 00 00 00 	movl   $0x4,-0x70(%edi)
        swtch(&(c->scheduler), p->context);
80104072:	59                   	pop    %ecx
80104073:	5e                   	pop    %esi
80104074:	ff 77 a0             	pushl  -0x60(%edi)
80104077:	ff 75 e4             	pushl  -0x1c(%ebp)
8010407a:	e8 94 0e 00 00       	call   80104f13 <swtch>
        switchkvm();
8010407f:	e8 ac 30 00 00       	call   80107130 <switchkvm>
        c->proc = 0;
80104084:	83 c4 10             	add    $0x10,%esp
80104087:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010408e:	00 00 00 
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104091:	81 ff 74 a6 11 80    	cmp    $0x8011a674,%edi
80104097:	0f 82 5d ff ff ff    	jb     80103ffa <scheduler+0xfa>
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409d:	bf 74 82 11 80       	mov    $0x80118274,%edi
        if(p->state != RUNNABLE)
801040a2:	83 7f 20 03          	cmpl   $0x3,0x20(%edi)
801040a6:	74 23                	je     801040cb <scheduler+0x1cb>
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a8:	81 c7 90 00 00 00    	add    $0x90,%edi
801040ae:	81 ff 74 a6 11 80    	cmp    $0x8011a674,%edi
801040b4:	72 ec                	jb     801040a2 <scheduler+0x1a2>
      release(&ptable.lock);
801040b6:	83 ec 0c             	sub    $0xc,%esp
801040b9:	68 40 82 11 80       	push   $0x80118240
801040be:	e8 dd 0b 00 00       	call   80104ca0 <release>
  for(;;){
801040c3:	83 c4 10             	add    $0x10,%esp
801040c6:	e9 59 fe ff ff       	jmp    80103f24 <scheduler+0x24>
          if(p->ticks > CYCLE_AGE_LIMIT && p->prio > 4)
801040cb:	8b 57 04             	mov    0x4(%edi),%edx
801040ce:	81 fa e8 03 00 00    	cmp    $0x3e8,%edx
801040d4:	76 0e                	jbe    801040e4 <scheduler+0x1e4>
801040d6:	8b 47 10             	mov    0x10(%edi),%eax
801040d9:	83 f8 04             	cmp    $0x4,%eax
801040dc:	7e 06                	jle    801040e4 <scheduler+0x1e4>
            p->prio --;
801040de:	83 e8 01             	sub    $0x1,%eax
801040e1:	89 47 10             	mov    %eax,0x10(%edi)
        for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
801040e4:	b8 74 82 11 80       	mov    $0x80118274,%eax
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          if(p1->state != RUNNABLE)
801040f0:	83 78 20 03          	cmpl   $0x3,0x20(%eax)
801040f4:	75 06                	jne    801040fc <scheduler+0x1fc>
          if(p1->ticks > p->ticks)   //the one with the right number of tickets
801040f6:	3b 50 04             	cmp    0x4(%eax),%edx
801040f9:	0f 42 f8             	cmovb  %eax,%edi
        for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
801040fc:	05 90 00 00 00       	add    $0x90,%eax
80104101:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
80104106:	75 e8                	jne    801040f0 <scheduler+0x1f0>
        switchuvm(p);
80104108:	83 ec 0c             	sub    $0xc,%esp
        p->ticks++;
8010410b:	83 47 04 01          	addl   $0x1,0x4(%edi)
        c->proc = p;
8010410f:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
80104115:	57                   	push   %edi
80104116:	e8 35 30 00 00       	call   80107150 <switchuvm>
        p->state = RUNNING;
8010411b:	c7 47 20 04 00 00 00 	movl   $0x4,0x20(%edi)
        swtch(&(c->scheduler), p->context);
80104122:	58                   	pop    %eax
80104123:	5a                   	pop    %edx
80104124:	ff 77 30             	pushl  0x30(%edi)
80104127:	ff 75 e4             	pushl  -0x1c(%ebp)
8010412a:	e8 e4 0d 00 00       	call   80104f13 <swtch>
        switchkvm();
8010412f:	e8 fc 2f 00 00       	call   80107130 <switchkvm>
        c->proc = 0;
80104134:	83 c4 10             	add    $0x10,%esp
80104137:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010413e:	00 00 00 
80104141:	e9 62 ff ff ff       	jmp    801040a8 <scheduler+0x1a8>
80104146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414d:	8d 76 00             	lea    0x0(%esi),%esi

80104150 <sched>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	56                   	push   %esi
80104158:	53                   	push   %ebx
  pushcli();
80104159:	e8 82 09 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010415e:	e8 ed f9 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104163:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104169:	e8 c2 09 00 00       	call   80104b30 <popcli>
  if(!holding(&ptable.lock))
8010416e:	83 ec 0c             	sub    $0xc,%esp
80104171:	68 40 82 11 80       	push   $0x80118240
80104176:	e8 15 0a 00 00       	call   80104b90 <holding>
8010417b:	83 c4 10             	add    $0x10,%esp
8010417e:	85 c0                	test   %eax,%eax
80104180:	74 4f                	je     801041d1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104182:	e8 c9 f9 ff ff       	call   80103b50 <mycpu>
80104187:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010418e:	75 68                	jne    801041f8 <sched+0xa8>
  if(p->state == RUNNING)
80104190:	83 7b 20 04          	cmpl   $0x4,0x20(%ebx)
80104194:	74 55                	je     801041eb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104196:	9c                   	pushf  
80104197:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104198:	f6 c4 02             	test   $0x2,%ah
8010419b:	75 41                	jne    801041de <sched+0x8e>
  intena = mycpu()->intena;
8010419d:	e8 ae f9 ff ff       	call   80103b50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041a2:	83 c3 30             	add    $0x30,%ebx
  intena = mycpu()->intena;
801041a5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041ab:	e8 a0 f9 ff ff       	call   80103b50 <mycpu>
801041b0:	83 ec 08             	sub    $0x8,%esp
801041b3:	ff 70 04             	pushl  0x4(%eax)
801041b6:	53                   	push   %ebx
801041b7:	e8 57 0d 00 00       	call   80104f13 <swtch>
  mycpu()->intena = intena;
801041bc:	e8 8f f9 ff ff       	call   80103b50 <mycpu>
}
801041c1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801041c4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041cd:	5b                   	pop    %ebx
801041ce:	5e                   	pop    %esi
801041cf:	5d                   	pop    %ebp
801041d0:	c3                   	ret    
    panic("sched ptable.lock");
801041d1:	83 ec 0c             	sub    $0xc,%esp
801041d4:	68 9b 7d 10 80       	push   $0x80107d9b
801041d9:	e8 b2 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801041de:	83 ec 0c             	sub    $0xc,%esp
801041e1:	68 c7 7d 10 80       	push   $0x80107dc7
801041e6:	e8 a5 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	68 b9 7d 10 80       	push   $0x80107db9
801041f3:	e8 98 c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 ad 7d 10 80       	push   $0x80107dad
80104200:	e8 8b c1 ff ff       	call   80100390 <panic>
80104205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104210 <exit>:
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	57                   	push   %edi
80104218:	56                   	push   %esi
80104219:	53                   	push   %ebx
8010421a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010421d:	e8 be 08 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104222:	e8 29 f9 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104227:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010422d:	e8 fe 08 00 00       	call   80104b30 <popcli>
  if(curproc == initproc)
80104232:	8d 5e 3c             	lea    0x3c(%esi),%ebx
80104235:	8d 7e 7c             	lea    0x7c(%esi),%edi
80104238:	39 35 90 ba 10 80    	cmp    %esi,0x8010ba90
8010423e:	0f 84 fd 00 00 00    	je     80104341 <exit+0x131>
80104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104248:	8b 03                	mov    (%ebx),%eax
8010424a:	85 c0                	test   %eax,%eax
8010424c:	74 12                	je     80104260 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010424e:	83 ec 0c             	sub    $0xc,%esp
80104251:	50                   	push   %eax
80104252:	e8 79 cc ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80104257:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010425d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104260:	83 c3 04             	add    $0x4,%ebx
80104263:	39 df                	cmp    %ebx,%edi
80104265:	75 e1                	jne    80104248 <exit+0x38>
  begin_op();
80104267:	e8 d4 ea ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	ff 76 7c             	pushl  0x7c(%esi)
80104272:	e8 29 d6 ff ff       	call   801018a0 <iput>
  end_op();
80104277:	e8 34 eb ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
8010427c:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  acquire(&ptable.lock);
80104283:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
8010428a:	e8 51 09 00 00       	call   80104be0 <acquire>
  wakeup1(curproc->parent);
8010428f:	8b 56 28             	mov    0x28(%esi),%edx
80104292:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104295:	b8 74 82 11 80       	mov    $0x80118274,%eax
8010429a:	eb 10                	jmp    801042ac <exit+0x9c>
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a0:	05 90 00 00 00       	add    $0x90,%eax
801042a5:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
801042aa:	74 1e                	je     801042ca <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan){
801042ac:	83 78 20 02          	cmpl   $0x2,0x20(%eax)
801042b0:	75 ee                	jne    801042a0 <exit+0x90>
801042b2:	3b 50 34             	cmp    0x34(%eax),%edx
801042b5:	75 e9                	jne    801042a0 <exit+0x90>
      p->state = RUNNABLE;
801042b7:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042be:	05 90 00 00 00       	add    $0x90,%eax
801042c3:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
801042c8:	75 e2                	jne    801042ac <exit+0x9c>
      p->parent = initproc;
801042ca:	8b 0d 90 ba 10 80    	mov    0x8010ba90,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d0:	ba 74 82 11 80       	mov    $0x80118274,%edx
801042d5:	eb 17                	jmp    801042ee <exit+0xde>
801042d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042de:	66 90                	xchg   %ax,%ax
801042e0:	81 c2 90 00 00 00    	add    $0x90,%edx
801042e6:	81 fa 74 a6 11 80    	cmp    $0x8011a674,%edx
801042ec:	74 3a                	je     80104328 <exit+0x118>
    if(p->parent == curproc){
801042ee:	39 72 28             	cmp    %esi,0x28(%edx)
801042f1:	75 ed                	jne    801042e0 <exit+0xd0>
      if(p->state == ZOMBIE)
801042f3:	83 7a 20 05          	cmpl   $0x5,0x20(%edx)
      p->parent = initproc;
801042f7:	89 4a 28             	mov    %ecx,0x28(%edx)
      if(p->state == ZOMBIE)
801042fa:	75 e4                	jne    801042e0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042fc:	b8 74 82 11 80       	mov    $0x80118274,%eax
80104301:	eb 11                	jmp    80104314 <exit+0x104>
80104303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104307:	90                   	nop
80104308:	05 90 00 00 00       	add    $0x90,%eax
8010430d:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
80104312:	74 cc                	je     801042e0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan){
80104314:	83 78 20 02          	cmpl   $0x2,0x20(%eax)
80104318:	75 ee                	jne    80104308 <exit+0xf8>
8010431a:	3b 48 34             	cmp    0x34(%eax),%ecx
8010431d:	75 e9                	jne    80104308 <exit+0xf8>
      p->state = RUNNABLE;
8010431f:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
80104326:	eb e0                	jmp    80104308 <exit+0xf8>
  curproc->state = ZOMBIE;
80104328:	c7 46 20 05 00 00 00 	movl   $0x5,0x20(%esi)
  sched();
8010432f:	e8 1c fe ff ff       	call   80104150 <sched>
  panic("zombie exit");
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	68 e8 7d 10 80       	push   $0x80107de8
8010433c:	e8 4f c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104341:	83 ec 0c             	sub    $0xc,%esp
80104344:	68 db 7d 10 80       	push   $0x80107ddb
80104349:	e8 42 c0 ff ff       	call   80100390 <panic>
8010434e:	66 90                	xchg   %ax,%ax

80104350 <yield>:
{
80104350:	f3 0f 1e fb          	endbr32 
80104354:	55                   	push   %ebp
80104355:	89 e5                	mov    %esp,%ebp
80104357:	53                   	push   %ebx
80104358:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010435b:	68 40 82 11 80       	push   $0x80118240
80104360:	e8 7b 08 00 00       	call   80104be0 <acquire>
  pushcli();
80104365:	e8 76 07 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010436a:	e8 e1 f7 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010436f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104375:	e8 b6 07 00 00       	call   80104b30 <popcli>
  myproc()->state = RUNNABLE;
8010437a:	c7 43 20 03 00 00 00 	movl   $0x3,0x20(%ebx)
  sched();
80104381:	e8 ca fd ff ff       	call   80104150 <sched>
  release(&ptable.lock);
80104386:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
8010438d:	e8 0e 09 00 00       	call   80104ca0 <release>
}
80104392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104395:	83 c4 10             	add    $0x10,%esp
80104398:	c9                   	leave  
80104399:	c3                   	ret    
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <sleep>:
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	57                   	push   %edi
801043a8:	56                   	push   %esi
801043a9:	53                   	push   %ebx
801043aa:	83 ec 0c             	sub    $0xc,%esp
801043ad:	8b 7d 08             	mov    0x8(%ebp),%edi
801043b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043b3:	e8 28 07 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
801043b8:	e8 93 f7 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
801043bd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043c3:	e8 68 07 00 00       	call   80104b30 <popcli>
  if(p == 0)
801043c8:	85 db                	test   %ebx,%ebx
801043ca:	0f 84 83 00 00 00    	je     80104453 <sleep+0xb3>
  if(lk == 0)
801043d0:	85 f6                	test   %esi,%esi
801043d2:	74 72                	je     80104446 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043d4:	81 fe 40 82 11 80    	cmp    $0x80118240,%esi
801043da:	74 4c                	je     80104428 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	68 40 82 11 80       	push   $0x80118240
801043e4:	e8 f7 07 00 00       	call   80104be0 <acquire>
    release(lk);
801043e9:	89 34 24             	mov    %esi,(%esp)
801043ec:	e8 af 08 00 00       	call   80104ca0 <release>
  p->chan = chan;
801043f1:	89 7b 34             	mov    %edi,0x34(%ebx)
  p->state = SLEEPING;
801043f4:	c7 43 20 02 00 00 00 	movl   $0x2,0x20(%ebx)
  sched();
801043fb:	e8 50 fd ff ff       	call   80104150 <sched>
  p->chan = 0;
80104400:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
    release(&ptable.lock);
80104407:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
8010440e:	e8 8d 08 00 00       	call   80104ca0 <release>
    acquire(lk);
80104413:	89 75 08             	mov    %esi,0x8(%ebp)
80104416:	83 c4 10             	add    $0x10,%esp
}
80104419:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010441c:	5b                   	pop    %ebx
8010441d:	5e                   	pop    %esi
8010441e:	5f                   	pop    %edi
8010441f:	5d                   	pop    %ebp
    acquire(lk);
80104420:	e9 bb 07 00 00       	jmp    80104be0 <acquire>
80104425:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104428:	89 7b 34             	mov    %edi,0x34(%ebx)
  p->state = SLEEPING;
8010442b:	c7 43 20 02 00 00 00 	movl   $0x2,0x20(%ebx)
  sched();
80104432:	e8 19 fd ff ff       	call   80104150 <sched>
  p->chan = 0;
80104437:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
}
8010443e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104441:	5b                   	pop    %ebx
80104442:	5e                   	pop    %esi
80104443:	5f                   	pop    %edi
80104444:	5d                   	pop    %ebp
80104445:	c3                   	ret    
    panic("sleep without lk");
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	68 fa 7d 10 80       	push   $0x80107dfa
8010444e:	e8 3d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 f4 7d 10 80       	push   $0x80107df4
8010445b:	e8 30 bf ff ff       	call   80100390 <panic>

80104460 <wait>:
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
80104465:	89 e5                	mov    %esp,%ebp
80104467:	56                   	push   %esi
80104468:	53                   	push   %ebx
  pushcli();
80104469:	e8 72 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010446e:	e8 dd f6 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104473:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104479:	e8 b2 06 00 00       	call   80104b30 <popcli>
  acquire(&ptable.lock);
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	68 40 82 11 80       	push   $0x80118240
80104486:	e8 55 07 00 00       	call   80104be0 <acquire>
8010448b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010448e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104490:	bb 74 82 11 80       	mov    $0x80118274,%ebx
80104495:	eb 17                	jmp    801044ae <wait+0x4e>
80104497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449e:	66 90                	xchg   %ax,%ax
801044a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801044a6:	81 fb 74 a6 11 80    	cmp    $0x8011a674,%ebx
801044ac:	74 1e                	je     801044cc <wait+0x6c>
      if(p->parent != curproc)
801044ae:	39 73 28             	cmp    %esi,0x28(%ebx)
801044b1:	75 ed                	jne    801044a0 <wait+0x40>
      if(p->state == ZOMBIE){
801044b3:	83 7b 20 05          	cmpl   $0x5,0x20(%ebx)
801044b7:	74 37                	je     801044f0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
801044bf:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c4:	81 fb 74 a6 11 80    	cmp    $0x8011a674,%ebx
801044ca:	75 e2                	jne    801044ae <wait+0x4e>
    if(!havekids || curproc->killed){
801044cc:	85 c0                	test   %eax,%eax
801044ce:	0f 84 7c 00 00 00    	je     80104550 <wait+0xf0>
801044d4:	8b 46 38             	mov    0x38(%esi),%eax
801044d7:	85 c0                	test   %eax,%eax
801044d9:	75 75                	jne    80104550 <wait+0xf0>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044db:	83 ec 08             	sub    $0x8,%esp
801044de:	68 40 82 11 80       	push   $0x80118240
801044e3:	56                   	push   %esi
801044e4:	e8 b7 fe ff ff       	call   801043a0 <sleep>
    havekids = 0;
801044e9:	83 c4 10             	add    $0x10,%esp
801044ec:	eb a0                	jmp    8010448e <wait+0x2e>
801044ee:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	ff 73 1c             	pushl  0x1c(%ebx)
        pid = p->pid;
801044f6:	8b 73 24             	mov    0x24(%ebx),%esi
        kfree(p->kstack);
801044f9:	e8 82 df ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
801044fe:	5a                   	pop    %edx
801044ff:	ff 73 18             	pushl  0x18(%ebx)
        p->kstack = 0;
80104502:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        freevm(p->pgdir);
80104509:	e8 02 30 00 00       	call   80107510 <freevm>
        release(&ptable.lock);
8010450e:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
        p->pid = 0;
80104515:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->parent = 0;
8010451c:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->name[0] = 0;
80104523:	c6 83 80 00 00 00 00 	movb   $0x0,0x80(%ebx)
        p->killed = 0;
8010452a:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
        p->ticks = 0;
80104531:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->state = UNUSED;
80104538:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
8010453f:	e8 5c 07 00 00       	call   80104ca0 <release>
        return pid;
80104544:	83 c4 10             	add    $0x10,%esp
}
80104547:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010454a:	89 f0                	mov    %esi,%eax
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    
      release(&ptable.lock);
80104550:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104553:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104558:	68 40 82 11 80       	push   $0x80118240
8010455d:	e8 3e 07 00 00       	call   80104ca0 <release>
      return -1;
80104562:	83 c4 10             	add    $0x10,%esp
80104565:	eb e0                	jmp    80104547 <wait+0xe7>
80104567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456e:	66 90                	xchg   %ax,%ax

80104570 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	53                   	push   %ebx
80104578:	83 ec 10             	sub    $0x10,%esp
8010457b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010457e:	68 40 82 11 80       	push   $0x80118240
80104583:	e8 58 06 00 00       	call   80104be0 <acquire>
80104588:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010458b:	b8 74 82 11 80       	mov    $0x80118274,%eax
80104590:	eb 12                	jmp    801045a4 <wakeup+0x34>
80104592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104598:	05 90 00 00 00       	add    $0x90,%eax
8010459d:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
801045a2:	74 1e                	je     801045c2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan){
801045a4:	83 78 20 02          	cmpl   $0x2,0x20(%eax)
801045a8:	75 ee                	jne    80104598 <wakeup+0x28>
801045aa:	3b 58 34             	cmp    0x34(%eax),%ebx
801045ad:	75 e9                	jne    80104598 <wakeup+0x28>
      p->state = RUNNABLE;
801045af:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045b6:	05 90 00 00 00       	add    $0x90,%eax
801045bb:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
801045c0:	75 e2                	jne    801045a4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801045c2:	c7 45 08 40 82 11 80 	movl   $0x80118240,0x8(%ebp)
}
801045c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045cc:	c9                   	leave  
  release(&ptable.lock);
801045cd:	e9 ce 06 00 00       	jmp    80104ca0 <release>
801045d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	53                   	push   %ebx
801045e8:	83 ec 10             	sub    $0x10,%esp
801045eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045ee:	68 40 82 11 80       	push   $0x80118240
801045f3:	e8 e8 05 00 00       	call   80104be0 <acquire>
801045f8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045fb:	b8 74 82 11 80       	mov    $0x80118274,%eax
80104600:	eb 12                	jmp    80104614 <kill+0x34>
80104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104608:	05 90 00 00 00       	add    $0x90,%eax
8010460d:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
80104612:	74 34                	je     80104648 <kill+0x68>
    if(p->pid == pid){
80104614:	39 58 24             	cmp    %ebx,0x24(%eax)
80104617:	75 ef                	jne    80104608 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80104619:	83 78 20 02          	cmpl   $0x2,0x20(%eax)
      p->killed = 1;
8010461d:	c7 40 38 01 00 00 00 	movl   $0x1,0x38(%eax)
      if(p->state == SLEEPING){
80104624:	75 07                	jne    8010462d <kill+0x4d>
        p->state = RUNNABLE;
80104626:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
      }
        
      release(&ptable.lock);
8010462d:	83 ec 0c             	sub    $0xc,%esp
80104630:	68 40 82 11 80       	push   $0x80118240
80104635:	e8 66 06 00 00       	call   80104ca0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010463a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	31 c0                	xor    %eax,%eax
}
80104642:	c9                   	leave  
80104643:	c3                   	ret    
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 40 82 11 80       	push   $0x80118240
80104650:	e8 4b 06 00 00       	call   80104ca0 <release>
}
80104655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104658:	83 c4 10             	add    $0x10,%esp
8010465b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104660:	c9                   	leave  
80104661:	c3                   	ret    
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	57                   	push   %edi
80104678:	56                   	push   %esi
80104679:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010467c:	53                   	push   %ebx
8010467d:	bb f4 82 11 80       	mov    $0x801182f4,%ebx
80104682:	83 ec 3c             	sub    $0x3c,%esp
80104685:	eb 2b                	jmp    801046b2 <procdump+0x42>
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	68 2b 7e 10 80       	push   $0x80107e2b
80104698:	e8 13 c0 ff ff       	call   801006b0 <cprintf>
8010469d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801046a6:	81 fb f4 a6 11 80    	cmp    $0x8011a6f4,%ebx
801046ac:	0f 84 8e 00 00 00    	je     80104740 <procdump+0xd0>
    if(p->state == UNUSED)
801046b2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046b5:	85 c0                	test   %eax,%eax
801046b7:	74 e7                	je     801046a0 <procdump+0x30>
      state = "???";
801046b9:	ba 0b 7e 10 80       	mov    $0x80107e0b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046be:	83 f8 05             	cmp    $0x5,%eax
801046c1:	77 11                	ja     801046d4 <procdump+0x64>
801046c3:	8b 14 85 2c 7f 10 80 	mov    -0x7fef80d4(,%eax,4),%edx
      state = "???";
801046ca:	b8 0b 7e 10 80       	mov    $0x80107e0b,%eax
801046cf:	85 d2                	test   %edx,%edx
801046d1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046d4:	53                   	push   %ebx
801046d5:	52                   	push   %edx
801046d6:	ff 73 a4             	pushl  -0x5c(%ebx)
801046d9:	68 0f 7e 10 80       	push   $0x80107e0f
801046de:	e8 cd bf ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801046e3:	83 c4 10             	add    $0x10,%esp
801046e6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046ea:	75 a4                	jne    80104690 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046ec:	83 ec 08             	sub    $0x8,%esp
801046ef:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046f2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046f5:	50                   	push   %eax
801046f6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801046f9:	8b 40 0c             	mov    0xc(%eax),%eax
801046fc:	83 c0 08             	add    $0x8,%eax
801046ff:	50                   	push   %eax
80104700:	e8 7b 03 00 00       	call   80104a80 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104705:	83 c4 10             	add    $0x10,%esp
80104708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop
80104710:	8b 17                	mov    (%edi),%edx
80104712:	85 d2                	test   %edx,%edx
80104714:	0f 84 76 ff ff ff    	je     80104690 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010471a:	83 ec 08             	sub    $0x8,%esp
8010471d:	83 c7 04             	add    $0x4,%edi
80104720:	52                   	push   %edx
80104721:	68 61 78 10 80       	push   $0x80107861
80104726:	e8 85 bf ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010472b:	83 c4 10             	add    $0x10,%esp
8010472e:	39 fe                	cmp    %edi,%esi
80104730:	75 de                	jne    80104710 <procdump+0xa0>
80104732:	e9 59 ff ff ff       	jmp    80104690 <procdump+0x20>
80104737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473e:	66 90                	xchg   %ax,%ax
  }
}
80104740:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104743:	5b                   	pop    %ebx
80104744:	5e                   	pop    %esi
80104745:	5f                   	pop    %edi
80104746:	5d                   	pop    %ebp
80104747:	c3                   	ret    
80104748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474f:	90                   	nop

80104750 <cps>:

int
cps()
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	53                   	push   %ebx
80104758:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
8010475b:	fb                   	sti    
struct proc *p;
//Enables interrupts on this processor.
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
8010475c:	68 40 82 11 80       	push   $0x80118240
cprintf("name \t pid \t state \t\t priority  tickets  arrival \n");
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104761:	bb 74 82 11 80       	mov    $0x80118274,%ebx
acquire(&ptable.lock);
80104766:	e8 75 04 00 00       	call   80104be0 <acquire>
cprintf("name \t pid \t state \t\t priority  tickets  arrival \n");
8010476b:	c7 04 24 80 7e 10 80 	movl   $0x80107e80,(%esp)
80104772:	e8 39 bf ff ff       	call   801006b0 <cprintf>
80104777:	83 c4 10             	add    $0x10,%esp
8010477a:	eb 20                	jmp    8010479c <cps+0x4c>
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(p->state == SLEEPING)
	  cprintf("%s \t %d \t SLEEPING \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
	else if(p->state == RUNNING)
80104780:	83 f8 04             	cmp    $0x4,%eax
80104783:	74 6b                	je     801047f0 <cps+0xa0>
 	  cprintf("%s \t %d \t RUNNING \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
	else if(p->state == RUNNABLE)
80104785:	83 f8 03             	cmp    $0x3,%eax
80104788:	0f 84 92 00 00 00    	je     80104820 <cps+0xd0>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010478e:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104794:	81 fb 74 a6 11 80    	cmp    $0x8011a674,%ebx
8010479a:	74 3c                	je     801047d8 <cps+0x88>
  if(p->state == SLEEPING)
8010479c:	8b 43 20             	mov    0x20(%ebx),%eax
8010479f:	83 f8 02             	cmp    $0x2,%eax
801047a2:	75 dc                	jne    80104780 <cps+0x30>
	  cprintf("%s \t %d \t SLEEPING \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
801047a4:	83 ec 08             	sub    $0x8,%esp
801047a7:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801047ad:	ff 73 04             	pushl  0x4(%ebx)
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b0:	81 c3 90 00 00 00    	add    $0x90,%ebx
	  cprintf("%s \t %d \t SLEEPING \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
801047b6:	ff b3 78 ff ff ff    	pushl  -0x88(%ebx)
801047bc:	ff 73 80             	pushl  -0x80(%ebx)
801047bf:	ff 73 94             	pushl  -0x6c(%ebx)
801047c2:	50                   	push   %eax
801047c3:	68 b4 7e 10 80       	push   $0x80107eb4
801047c8:	e8 e3 be ff ff       	call   801006b0 <cprintf>
801047cd:	83 c4 20             	add    $0x20,%esp
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d0:	81 fb 74 a6 11 80    	cmp    $0x8011a674,%ebx
801047d6:	75 c4                	jne    8010479c <cps+0x4c>
 	  cprintf("%s \t %d \t RUNNABLE \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
}
release(&ptable.lock);
801047d8:	83 ec 0c             	sub    $0xc,%esp
801047db:	68 40 82 11 80       	push   $0x80118240
801047e0:	e8 bb 04 00 00       	call   80104ca0 <release>
return 22;
}
801047e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e8:	b8 16 00 00 00       	mov    $0x16,%eax
801047ed:	c9                   	leave  
801047ee:	c3                   	ret    
801047ef:	90                   	nop
 	  cprintf("%s \t %d \t RUNNING \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
801047f0:	83 ec 08             	sub    $0x8,%esp
801047f3:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801047f9:	ff 73 04             	pushl  0x4(%ebx)
801047fc:	ff 73 08             	pushl  0x8(%ebx)
801047ff:	ff 73 10             	pushl  0x10(%ebx)
80104802:	ff 73 24             	pushl  0x24(%ebx)
80104805:	50                   	push   %eax
80104806:	68 dc 7e 10 80       	push   $0x80107edc
8010480b:	e8 a0 be ff ff       	call   801006b0 <cprintf>
80104810:	83 c4 20             	add    $0x20,%esp
80104813:	e9 76 ff ff ff       	jmp    8010478e <cps+0x3e>
80104818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop
 	  cprintf("%s \t %d \t RUNNABLE \t %d \t\t %d \t %d \n ", p->name,p->pid,p->prio,p->tickets,p->ticks);
80104820:	83 ec 08             	sub    $0x8,%esp
80104823:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104829:	ff 73 04             	pushl  0x4(%ebx)
8010482c:	ff 73 08             	pushl  0x8(%ebx)
8010482f:	ff 73 10             	pushl  0x10(%ebx)
80104832:	ff 73 24             	pushl  0x24(%ebx)
80104835:	50                   	push   %eax
80104836:	68 04 7f 10 80       	push   $0x80107f04
8010483b:	e8 70 be ff ff       	call   801006b0 <cprintf>
80104840:	83 c4 20             	add    $0x20,%esp
80104843:	e9 46 ff ff ff       	jmp    8010478e <cps+0x3e>
80104848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop

80104850 <chpr>:

int 
chpr(int pid, int priority)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	56                   	push   %esi
80104858:	53                   	push   %ebx
80104859:	8b 75 08             	mov    0x8(%ebp),%esi
	struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010485c:	bb 74 82 11 80       	mov    $0x80118274,%ebx
	acquire(&ptable.lock);
80104861:	83 ec 0c             	sub    $0xc,%esp
80104864:	68 40 82 11 80       	push   $0x80118240
80104869:	e8 72 03 00 00       	call   80104be0 <acquire>
8010486e:	83 c4 10             	add    $0x10,%esp
80104871:	eb 13                	jmp    80104886 <chpr+0x36>
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104878:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010487e:	81 fb 74 a6 11 80    	cmp    $0x8011a674,%ebx
80104884:	74 0c                	je     80104892 <chpr+0x42>
	  if(p->pid == pid){
80104886:	39 73 24             	cmp    %esi,0x24(%ebx)
80104889:	75 ed                	jne    80104878 <chpr+0x28>
			p->prio = 3;
8010488b:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
			break;
		}
	}

  cprintf("\npid  prio\n");
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 18 7e 10 80       	push   $0x80107e18
8010489a:	e8 11 be ff ff       	call   801006b0 <cprintf>
  cprintf("%d  %d \n", p->pid, p->prio);
8010489f:	83 c4 0c             	add    $0xc,%esp
801048a2:	ff 73 10             	pushl  0x10(%ebx)
801048a5:	ff 73 24             	pushl  0x24(%ebx)
801048a8:	68 24 7e 10 80       	push   $0x80107e24
801048ad:	e8 fe bd ff ff       	call   801006b0 <cprintf>
	release(&ptable.lock);
801048b2:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
801048b9:	e8 e2 03 00 00       	call   80104ca0 <release>
	return pid;
}
801048be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c1:	89 f0                	mov    %esi,%eax
801048c3:	5b                   	pop    %ebx
801048c4:	5e                   	pop    %esi
801048c5:	5d                   	pop    %ebp
801048c6:	c3                   	ret    
801048c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <withput_ticket_proc>:

void withput_ticket_proc(int pid){
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	53                   	push   %ebx
801048d8:	83 ec 10             	sub    $0x10,%esp
801048db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;
    acquire(&ptable.lock);
801048de:	68 40 82 11 80       	push   $0x80118240
801048e3:	e8 f8 02 00 00       	call   80104be0 <acquire>
801048e8:	83 c4 10             	add    $0x10,%esp

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048eb:	b8 74 82 11 80       	mov    $0x80118274,%eax
801048f0:	eb 12                	jmp    80104904 <withput_ticket_proc+0x34>
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f8:	05 90 00 00 00       	add    $0x90,%eax
801048fd:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
80104902:	74 0c                	je     80104910 <withput_ticket_proc+0x40>
      if(p->pid == pid){
80104904:	39 58 24             	cmp    %ebx,0x24(%eax)
80104907:	75 ef                	jne    801048f8 <withput_ticket_proc+0x28>
        p->tickets = 0;
80104909:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        break;
      }
    }

    release(&ptable.lock);
80104910:	c7 45 08 40 82 11 80 	movl   $0x80118240,0x8(%ebp)
}
80104917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010491a:	c9                   	leave  
    release(&ptable.lock);
8010491b:	e9 80 03 00 00       	jmp    80104ca0 <release>

80104920 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	53                   	push   %ebx
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010492e:	68 44 7f 10 80       	push   $0x80107f44
80104933:	8d 43 04             	lea    0x4(%ebx),%eax
80104936:	50                   	push   %eax
80104937:	e8 24 01 00 00       	call   80104a60 <initlock>
  lk->name = name;
8010493c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010493f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104945:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104948:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010494f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104955:	c9                   	leave  
80104956:	c3                   	ret    
80104957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495e:	66 90                	xchg   %ax,%ax

80104960 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	56                   	push   %esi
80104968:	53                   	push   %ebx
80104969:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010496c:	8d 73 04             	lea    0x4(%ebx),%esi
8010496f:	83 ec 0c             	sub    $0xc,%esp
80104972:	56                   	push   %esi
80104973:	e8 68 02 00 00       	call   80104be0 <acquire>
  while (lk->locked) {
80104978:	8b 13                	mov    (%ebx),%edx
8010497a:	83 c4 10             	add    $0x10,%esp
8010497d:	85 d2                	test   %edx,%edx
8010497f:	74 1a                	je     8010499b <acquiresleep+0x3b>
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104988:	83 ec 08             	sub    $0x8,%esp
8010498b:	56                   	push   %esi
8010498c:	53                   	push   %ebx
8010498d:	e8 0e fa ff ff       	call   801043a0 <sleep>
  while (lk->locked) {
80104992:	8b 03                	mov    (%ebx),%eax
80104994:	83 c4 10             	add    $0x10,%esp
80104997:	85 c0                	test   %eax,%eax
80104999:	75 ed                	jne    80104988 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010499b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049a1:	e8 3a f2 ff ff       	call   80103be0 <myproc>
801049a6:	8b 40 24             	mov    0x24(%eax),%eax
801049a9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049ac:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
  release(&lk->lk);
801049b5:	e9 e6 02 00 00       	jmp    80104ca0 <release>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	56                   	push   %esi
801049c8:	53                   	push   %ebx
801049c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049cc:	8d 73 04             	lea    0x4(%ebx),%esi
801049cf:	83 ec 0c             	sub    $0xc,%esp
801049d2:	56                   	push   %esi
801049d3:	e8 08 02 00 00       	call   80104be0 <acquire>
  lk->locked = 0;
801049d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049de:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049e5:	89 1c 24             	mov    %ebx,(%esp)
801049e8:	e8 83 fb ff ff       	call   80104570 <wakeup>
  release(&lk->lk);
801049ed:	89 75 08             	mov    %esi,0x8(%ebp)
801049f0:	83 c4 10             	add    $0x10,%esp
}
801049f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f6:	5b                   	pop    %ebx
801049f7:	5e                   	pop    %esi
801049f8:	5d                   	pop    %ebp
  release(&lk->lk);
801049f9:	e9 a2 02 00 00       	jmp    80104ca0 <release>
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	57                   	push   %edi
80104a08:	31 ff                	xor    %edi,%edi
80104a0a:	56                   	push   %esi
80104a0b:	53                   	push   %ebx
80104a0c:	83 ec 18             	sub    $0x18,%esp
80104a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a12:	8d 73 04             	lea    0x4(%ebx),%esi
80104a15:	56                   	push   %esi
80104a16:	e8 c5 01 00 00       	call   80104be0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a1b:	8b 03                	mov    (%ebx),%eax
80104a1d:	83 c4 10             	add    $0x10,%esp
80104a20:	85 c0                	test   %eax,%eax
80104a22:	75 1c                	jne    80104a40 <holdingsleep+0x40>
  release(&lk->lk);
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	56                   	push   %esi
80104a28:	e8 73 02 00 00       	call   80104ca0 <release>
  return r;
}
80104a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a30:	89 f8                	mov    %edi,%eax
80104a32:	5b                   	pop    %ebx
80104a33:	5e                   	pop    %esi
80104a34:	5f                   	pop    %edi
80104a35:	5d                   	pop    %ebp
80104a36:	c3                   	ret    
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104a40:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a43:	e8 98 f1 ff ff       	call   80103be0 <myproc>
80104a48:	39 58 24             	cmp    %ebx,0x24(%eax)
80104a4b:	0f 94 c0             	sete   %al
80104a4e:	0f b6 c0             	movzbl %al,%eax
80104a51:	89 c7                	mov    %eax,%edi
80104a53:	eb cf                	jmp    80104a24 <holdingsleep+0x24>
80104a55:	66 90                	xchg   %ax,%ax
80104a57:	66 90                	xchg   %ax,%ax
80104a59:	66 90                	xchg   %ax,%ax
80104a5b:	66 90                	xchg   %ax,%ax
80104a5d:	66 90                	xchg   %ax,%ax
80104a5f:	90                   	nop

80104a60 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a73:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a7d:	5d                   	pop    %ebp
80104a7e:	c3                   	ret    
80104a7f:	90                   	nop

80104a80 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a85:	31 d2                	xor    %edx,%edx
{
80104a87:	89 e5                	mov    %esp,%ebp
80104a89:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a8a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a90:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a97:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a98:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aa4:	77 1a                	ja     80104ac0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aa6:	8b 58 04             	mov    0x4(%eax),%ebx
80104aa9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104aac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104aaf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ab1:	83 fa 0a             	cmp    $0xa,%edx
80104ab4:	75 e2                	jne    80104a98 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ab6:	5b                   	pop    %ebx
80104ab7:	5d                   	pop    %ebp
80104ab8:	c3                   	ret    
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104ac0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ac3:	8d 51 28             	lea    0x28(%ecx),%edx
80104ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ad6:	83 c0 04             	add    $0x4,%eax
80104ad9:	39 d0                	cmp    %edx,%eax
80104adb:	75 f3                	jne    80104ad0 <getcallerpcs+0x50>
}
80104add:	5b                   	pop    %ebx
80104ade:	5d                   	pop    %ebp
80104adf:	c3                   	ret    

80104ae0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	53                   	push   %ebx
80104ae8:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104aeb:	9c                   	pushf  
80104aec:	5b                   	pop    %ebx
  asm volatile("cli");
80104aed:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aee:	e8 5d f0 ff ff       	call   80103b50 <mycpu>
80104af3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af9:	85 c0                	test   %eax,%eax
80104afb:	74 13                	je     80104b10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104afd:	e8 4e f0 ff ff       	call   80103b50 <mycpu>
80104b02:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b09:	83 c4 04             	add    $0x4,%esp
80104b0c:	5b                   	pop    %ebx
80104b0d:	5d                   	pop    %ebp
80104b0e:	c3                   	ret    
80104b0f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104b10:	e8 3b f0 ff ff       	call   80103b50 <mycpu>
80104b15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b21:	eb da                	jmp    80104afd <pushcli+0x1d>
80104b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <popcli>:

void
popcli(void)
{
80104b30:	f3 0f 1e fb          	endbr32 
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b3a:	9c                   	pushf  
80104b3b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b3c:	f6 c4 02             	test   $0x2,%ah
80104b3f:	75 31                	jne    80104b72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b41:	e8 0a f0 ff ff       	call   80103b50 <mycpu>
80104b46:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b4d:	78 30                	js     80104b7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b4f:	e8 fc ef ff ff       	call   80103b50 <mycpu>
80104b54:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b5a:	85 d2                	test   %edx,%edx
80104b5c:	74 02                	je     80104b60 <popcli+0x30>
    sti();
}
80104b5e:	c9                   	leave  
80104b5f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b60:	e8 eb ef ff ff       	call   80103b50 <mycpu>
80104b65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	74 ef                	je     80104b5e <popcli+0x2e>
  asm volatile("sti");
80104b6f:	fb                   	sti    
}
80104b70:	c9                   	leave  
80104b71:	c3                   	ret    
    panic("popcli - interruptible");
80104b72:	83 ec 0c             	sub    $0xc,%esp
80104b75:	68 4f 7f 10 80       	push   $0x80107f4f
80104b7a:	e8 11 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	68 66 7f 10 80       	push   $0x80107f66
80104b87:	e8 04 b8 ff ff       	call   80100390 <panic>
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <holding>:
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	56                   	push   %esi
80104b98:	53                   	push   %ebx
80104b99:	8b 75 08             	mov    0x8(%ebp),%esi
80104b9c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b9e:	e8 3d ff ff ff       	call   80104ae0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ba3:	8b 06                	mov    (%esi),%eax
80104ba5:	85 c0                	test   %eax,%eax
80104ba7:	75 0f                	jne    80104bb8 <holding+0x28>
  popcli();
80104ba9:	e8 82 ff ff ff       	call   80104b30 <popcli>
}
80104bae:	89 d8                	mov    %ebx,%eax
80104bb0:	5b                   	pop    %ebx
80104bb1:	5e                   	pop    %esi
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104bb8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bbb:	e8 90 ef ff ff       	call   80103b50 <mycpu>
80104bc0:	39 c3                	cmp    %eax,%ebx
80104bc2:	0f 94 c3             	sete   %bl
  popcli();
80104bc5:	e8 66 ff ff ff       	call   80104b30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104bca:	0f b6 db             	movzbl %bl,%ebx
}
80104bcd:	89 d8                	mov    %ebx,%eax
80104bcf:	5b                   	pop    %ebx
80104bd0:	5e                   	pop    %esi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104be0 <acquire>:
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	56                   	push   %esi
80104be8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104be9:	e8 f2 fe ff ff       	call   80104ae0 <pushcli>
  if(holding(lk))
80104bee:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	53                   	push   %ebx
80104bf5:	e8 96 ff ff ff       	call   80104b90 <holding>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	0f 85 7f 00 00 00    	jne    80104c84 <acquire+0xa4>
80104c05:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c07:	ba 01 00 00 00       	mov    $0x1,%edx
80104c0c:	eb 05                	jmp    80104c13 <acquire+0x33>
80104c0e:	66 90                	xchg   %ax,%ax
80104c10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c13:	89 d0                	mov    %edx,%eax
80104c15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c18:	85 c0                	test   %eax,%eax
80104c1a:	75 f4                	jne    80104c10 <acquire+0x30>
  __sync_synchronize();
80104c1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c24:	e8 27 ef ff ff       	call   80103b50 <mycpu>
80104c29:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c2c:	89 e8                	mov    %ebp,%eax
80104c2e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c30:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104c36:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104c3c:	77 22                	ja     80104c60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c3e:	8b 50 04             	mov    0x4(%eax),%edx
80104c41:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104c45:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c48:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c4a:	83 fe 0a             	cmp    $0xa,%esi
80104c4d:	75 e1                	jne    80104c30 <acquire+0x50>
}
80104c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c52:	5b                   	pop    %ebx
80104c53:	5e                   	pop    %esi
80104c54:	5d                   	pop    %ebp
80104c55:	c3                   	ret    
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104c60:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104c64:	83 c3 34             	add    $0x34,%ebx
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c76:	83 c0 04             	add    $0x4,%eax
80104c79:	39 d8                	cmp    %ebx,%eax
80104c7b:	75 f3                	jne    80104c70 <acquire+0x90>
}
80104c7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c80:	5b                   	pop    %ebx
80104c81:	5e                   	pop    %esi
80104c82:	5d                   	pop    %ebp
80104c83:	c3                   	ret    
    panic("acquire");
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	68 6d 7f 10 80       	push   $0x80107f6d
80104c8c:	e8 ff b6 ff ff       	call   80100390 <panic>
80104c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop

80104ca0 <release>:
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	53                   	push   %ebx
80104ca8:	83 ec 10             	sub    $0x10,%esp
80104cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104cae:	53                   	push   %ebx
80104caf:	e8 dc fe ff ff       	call   80104b90 <holding>
80104cb4:	83 c4 10             	add    $0x10,%esp
80104cb7:	85 c0                	test   %eax,%eax
80104cb9:	74 22                	je     80104cdd <release+0x3d>
  lk->pcs[0] = 0;
80104cbb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104cc9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104cd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd7:	c9                   	leave  
  popcli();
80104cd8:	e9 53 fe ff ff       	jmp    80104b30 <popcli>
    panic("release");
80104cdd:	83 ec 0c             	sub    $0xc,%esp
80104ce0:	68 75 7f 10 80       	push   $0x80107f75
80104ce5:	e8 a6 b6 ff ff       	call   80100390 <panic>
80104cea:	66 90                	xchg   %ax,%ax
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	57                   	push   %edi
80104cf8:	8b 55 08             	mov    0x8(%ebp),%edx
80104cfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cfe:	53                   	push   %ebx
80104cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104d02:	89 d7                	mov    %edx,%edi
80104d04:	09 cf                	or     %ecx,%edi
80104d06:	83 e7 03             	and    $0x3,%edi
80104d09:	75 25                	jne    80104d30 <memset+0x40>
    c &= 0xFF;
80104d0b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d0e:	c1 e0 18             	shl    $0x18,%eax
80104d11:	89 fb                	mov    %edi,%ebx
80104d13:	c1 e9 02             	shr    $0x2,%ecx
80104d16:	c1 e3 10             	shl    $0x10,%ebx
80104d19:	09 d8                	or     %ebx,%eax
80104d1b:	09 f8                	or     %edi,%eax
80104d1d:	c1 e7 08             	shl    $0x8,%edi
80104d20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d22:	89 d7                	mov    %edx,%edi
80104d24:	fc                   	cld    
80104d25:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d27:	5b                   	pop    %ebx
80104d28:	89 d0                	mov    %edx,%eax
80104d2a:	5f                   	pop    %edi
80104d2b:	5d                   	pop    %ebp
80104d2c:	c3                   	ret    
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104d30:	89 d7                	mov    %edx,%edi
80104d32:	fc                   	cld    
80104d33:	f3 aa                	rep stos %al,%es:(%edi)
80104d35:	5b                   	pop    %ebx
80104d36:	89 d0                	mov    %edx,%eax
80104d38:	5f                   	pop    %edi
80104d39:	5d                   	pop    %ebp
80104d3a:	c3                   	ret    
80104d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop

80104d40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	56                   	push   %esi
80104d48:	8b 75 10             	mov    0x10(%ebp),%esi
80104d4b:	8b 55 08             	mov    0x8(%ebp),%edx
80104d4e:	53                   	push   %ebx
80104d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d52:	85 f6                	test   %esi,%esi
80104d54:	74 2a                	je     80104d80 <memcmp+0x40>
80104d56:	01 c6                	add    %eax,%esi
80104d58:	eb 10                	jmp    80104d6a <memcmp+0x2a>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d60:	83 c0 01             	add    $0x1,%eax
80104d63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d66:	39 f0                	cmp    %esi,%eax
80104d68:	74 16                	je     80104d80 <memcmp+0x40>
    if(*s1 != *s2)
80104d6a:	0f b6 0a             	movzbl (%edx),%ecx
80104d6d:	0f b6 18             	movzbl (%eax),%ebx
80104d70:	38 d9                	cmp    %bl,%cl
80104d72:	74 ec                	je     80104d60 <memcmp+0x20>
      return *s1 - *s2;
80104d74:	0f b6 c1             	movzbl %cl,%eax
80104d77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d79:	5b                   	pop    %ebx
80104d7a:	5e                   	pop    %esi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret    
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	5b                   	pop    %ebx
  return 0;
80104d81:	31 c0                	xor    %eax,%eax
}
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi

80104d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	57                   	push   %edi
80104d98:	8b 55 08             	mov    0x8(%ebp),%edx
80104d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d9e:	56                   	push   %esi
80104d9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104da2:	39 d6                	cmp    %edx,%esi
80104da4:	73 2a                	jae    80104dd0 <memmove+0x40>
80104da6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104da9:	39 fa                	cmp    %edi,%edx
80104dab:	73 23                	jae    80104dd0 <memmove+0x40>
80104dad:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104db0:	85 c9                	test   %ecx,%ecx
80104db2:	74 13                	je     80104dc7 <memmove+0x37>
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104db8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104dbc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104dbf:	83 e8 01             	sub    $0x1,%eax
80104dc2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104dc5:	75 f1                	jne    80104db8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dc7:	5e                   	pop    %esi
80104dc8:	89 d0                	mov    %edx,%eax
80104dca:	5f                   	pop    %edi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104dd0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104dd3:	89 d7                	mov    %edx,%edi
80104dd5:	85 c9                	test   %ecx,%ecx
80104dd7:	74 ee                	je     80104dc7 <memmove+0x37>
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104de0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104de1:	39 f0                	cmp    %esi,%eax
80104de3:	75 fb                	jne    80104de0 <memmove+0x50>
}
80104de5:	5e                   	pop    %esi
80104de6:	89 d0                	mov    %edx,%eax
80104de8:	5f                   	pop    %edi
80104de9:	5d                   	pop    %ebp
80104dea:	c3                   	ret    
80104deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop

80104df0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104df0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104df4:	eb 9a                	jmp    80104d90 <memmove>
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi

80104e00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	56                   	push   %esi
80104e08:	8b 75 10             	mov    0x10(%ebp),%esi
80104e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e0e:	53                   	push   %ebx
80104e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104e12:	85 f6                	test   %esi,%esi
80104e14:	74 32                	je     80104e48 <strncmp+0x48>
80104e16:	01 c6                	add    %eax,%esi
80104e18:	eb 14                	jmp    80104e2e <strncmp+0x2e>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e20:	38 da                	cmp    %bl,%dl
80104e22:	75 14                	jne    80104e38 <strncmp+0x38>
    n--, p++, q++;
80104e24:	83 c0 01             	add    $0x1,%eax
80104e27:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e2a:	39 f0                	cmp    %esi,%eax
80104e2c:	74 1a                	je     80104e48 <strncmp+0x48>
80104e2e:	0f b6 11             	movzbl (%ecx),%edx
80104e31:	0f b6 18             	movzbl (%eax),%ebx
80104e34:	84 d2                	test   %dl,%dl
80104e36:	75 e8                	jne    80104e20 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e38:	0f b6 c2             	movzbl %dl,%eax
80104e3b:	29 d8                	sub    %ebx,%eax
}
80104e3d:	5b                   	pop    %ebx
80104e3e:	5e                   	pop    %esi
80104e3f:	5d                   	pop    %ebp
80104e40:	c3                   	ret    
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e48:	5b                   	pop    %ebx
    return 0;
80104e49:	31 c0                	xor    %eax,%eax
}
80104e4b:	5e                   	pop    %esi
80104e4c:	5d                   	pop    %ebp
80104e4d:	c3                   	ret    
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	57                   	push   %edi
80104e58:	56                   	push   %esi
80104e59:	8b 75 08             	mov    0x8(%ebp),%esi
80104e5c:	53                   	push   %ebx
80104e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e60:	89 f2                	mov    %esi,%edx
80104e62:	eb 1b                	jmp    80104e7f <strncpy+0x2f>
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e68:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e6f:	83 c2 01             	add    $0x1,%edx
80104e72:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104e76:	89 f9                	mov    %edi,%ecx
80104e78:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e7b:	84 c9                	test   %cl,%cl
80104e7d:	74 09                	je     80104e88 <strncpy+0x38>
80104e7f:	89 c3                	mov    %eax,%ebx
80104e81:	83 e8 01             	sub    $0x1,%eax
80104e84:	85 db                	test   %ebx,%ebx
80104e86:	7f e0                	jg     80104e68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e88:	89 d1                	mov    %edx,%ecx
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	7e 15                	jle    80104ea3 <strncpy+0x53>
80104e8e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104e90:	83 c1 01             	add    $0x1,%ecx
80104e93:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104e97:	89 c8                	mov    %ecx,%eax
80104e99:	f7 d0                	not    %eax
80104e9b:	01 d0                	add    %edx,%eax
80104e9d:	01 d8                	add    %ebx,%eax
80104e9f:	85 c0                	test   %eax,%eax
80104ea1:	7f ed                	jg     80104e90 <strncpy+0x40>
  return os;
}
80104ea3:	5b                   	pop    %ebx
80104ea4:	89 f0                	mov    %esi,%eax
80104ea6:	5e                   	pop    %esi
80104ea7:	5f                   	pop    %edi
80104ea8:	5d                   	pop    %ebp
80104ea9:	c3                   	ret    
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104eb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	56                   	push   %esi
80104eb8:	8b 55 10             	mov    0x10(%ebp),%edx
80104ebb:	8b 75 08             	mov    0x8(%ebp),%esi
80104ebe:	53                   	push   %ebx
80104ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ec2:	85 d2                	test   %edx,%edx
80104ec4:	7e 21                	jle    80104ee7 <safestrcpy+0x37>
80104ec6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104eca:	89 f2                	mov    %esi,%edx
80104ecc:	eb 12                	jmp    80104ee0 <safestrcpy+0x30>
80104ece:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ed0:	0f b6 08             	movzbl (%eax),%ecx
80104ed3:	83 c0 01             	add    $0x1,%eax
80104ed6:	83 c2 01             	add    $0x1,%edx
80104ed9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104edc:	84 c9                	test   %cl,%cl
80104ede:	74 04                	je     80104ee4 <safestrcpy+0x34>
80104ee0:	39 d8                	cmp    %ebx,%eax
80104ee2:	75 ec                	jne    80104ed0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ee4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ee7:	89 f0                	mov    %esi,%eax
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5d                   	pop    %ebp
80104eec:	c3                   	ret    
80104eed:	8d 76 00             	lea    0x0(%esi),%esi

80104ef0 <strlen>:

int
strlen(const char *s)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ef5:	31 c0                	xor    %eax,%eax
{
80104ef7:	89 e5                	mov    %esp,%ebp
80104ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104efc:	80 3a 00             	cmpb   $0x0,(%edx)
80104eff:	74 10                	je     80104f11 <strlen+0x21>
80104f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f08:	83 c0 01             	add    $0x1,%eax
80104f0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f0f:	75 f7                	jne    80104f08 <strlen+0x18>
    ;
  return n;
}
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret    

80104f13 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f13:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f17:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f1b:	55                   	push   %ebp
  pushl %ebx
80104f1c:	53                   	push   %ebx
  pushl %esi
80104f1d:	56                   	push   %esi
  pushl %edi
80104f1e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f1f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f21:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f23:	5f                   	pop    %edi
  popl %esi
80104f24:	5e                   	pop    %esi
  popl %ebx
80104f25:	5b                   	pop    %ebx
  popl %ebp
80104f26:	5d                   	pop    %ebp
  ret
80104f27:	c3                   	ret    
80104f28:	66 90                	xchg   %ax,%ax
80104f2a:	66 90                	xchg   %ax,%ax
80104f2c:	66 90                	xchg   %ax,%ax
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	53                   	push   %ebx
80104f38:	83 ec 04             	sub    $0x4,%esp
80104f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f3e:	e8 9d ec ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f43:	8b 40 14             	mov    0x14(%eax),%eax
80104f46:	39 d8                	cmp    %ebx,%eax
80104f48:	76 16                	jbe    80104f60 <fetchint+0x30>
80104f4a:	8d 53 04             	lea    0x4(%ebx),%edx
80104f4d:	39 d0                	cmp    %edx,%eax
80104f4f:	72 0f                	jb     80104f60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f51:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f54:	8b 13                	mov    (%ebx),%edx
80104f56:	89 10                	mov    %edx,(%eax)
  return 0;
80104f58:	31 c0                	xor    %eax,%eax
}
80104f5a:	83 c4 04             	add    $0x4,%esp
80104f5d:	5b                   	pop    %ebx
80104f5e:	5d                   	pop    %ebp
80104f5f:	c3                   	ret    
    return -1;
80104f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f65:	eb f3                	jmp    80104f5a <fetchint+0x2a>
80104f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6e:	66 90                	xchg   %ax,%ax

80104f70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	53                   	push   %ebx
80104f78:	83 ec 04             	sub    $0x4,%esp
80104f7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f7e:	e8 5d ec ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz)
80104f83:	39 58 14             	cmp    %ebx,0x14(%eax)
80104f86:	76 30                	jbe    80104fb8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f8b:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f8d:	8b 50 14             	mov    0x14(%eax),%edx
  for(s = *pp; s < ep; s++){
80104f90:	39 d3                	cmp    %edx,%ebx
80104f92:	73 24                	jae    80104fb8 <fetchstr+0x48>
80104f94:	89 d8                	mov    %ebx,%eax
80104f96:	eb 0f                	jmp    80104fa7 <fetchstr+0x37>
80104f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop
80104fa0:	83 c0 01             	add    $0x1,%eax
80104fa3:	39 c2                	cmp    %eax,%edx
80104fa5:	76 11                	jbe    80104fb8 <fetchstr+0x48>
    if(*s == 0)
80104fa7:	80 38 00             	cmpb   $0x0,(%eax)
80104faa:	75 f4                	jne    80104fa0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104fac:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104faf:	29 d8                	sub    %ebx,%eax
}
80104fb1:	5b                   	pop    %ebx
80104fb2:	5d                   	pop    %ebp
80104fb3:	c3                   	ret    
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	83 c4 04             	add    $0x4,%esp
    return -1;
80104fbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc0:	5b                   	pop    %ebx
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	56                   	push   %esi
80104fd8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd9:	e8 02 ec ff ff       	call   80103be0 <myproc>
80104fde:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe1:	8b 40 2c             	mov    0x2c(%eax),%eax
80104fe4:	8b 40 44             	mov    0x44(%eax),%eax
80104fe7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fea:	e8 f1 eb ff ff       	call   80103be0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ff2:	8b 40 14             	mov    0x14(%eax),%eax
80104ff5:	39 c6                	cmp    %eax,%esi
80104ff7:	73 17                	jae    80105010 <argint+0x40>
80104ff9:	8d 53 08             	lea    0x8(%ebx),%edx
80104ffc:	39 d0                	cmp    %edx,%eax
80104ffe:	72 10                	jb     80105010 <argint+0x40>
  *ip = *(int*)(addr);
80105000:	8b 45 0c             	mov    0xc(%ebp),%eax
80105003:	8b 53 04             	mov    0x4(%ebx),%edx
80105006:	89 10                	mov    %edx,(%eax)
  return 0;
80105008:	31 c0                	xor    %eax,%eax
}
8010500a:	5b                   	pop    %ebx
8010500b:	5e                   	pop    %esi
8010500c:	5d                   	pop    %ebp
8010500d:	c3                   	ret    
8010500e:	66 90                	xchg   %ax,%ax
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105015:	eb f3                	jmp    8010500a <argint+0x3a>
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax

80105020 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	56                   	push   %esi
80105028:	53                   	push   %ebx
80105029:	83 ec 10             	sub    $0x10,%esp
8010502c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010502f:	e8 ac eb ff ff       	call   80103be0 <myproc>
 
  if(argint(n, &i) < 0)
80105034:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105037:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105039:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503c:	50                   	push   %eax
8010503d:	ff 75 08             	pushl  0x8(%ebp)
80105040:	e8 8b ff ff ff       	call   80104fd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105045:	83 c4 10             	add    $0x10,%esp
80105048:	85 c0                	test   %eax,%eax
8010504a:	78 24                	js     80105070 <argptr+0x50>
8010504c:	85 db                	test   %ebx,%ebx
8010504e:	78 20                	js     80105070 <argptr+0x50>
80105050:	8b 56 14             	mov    0x14(%esi),%edx
80105053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105056:	39 c2                	cmp    %eax,%edx
80105058:	76 16                	jbe    80105070 <argptr+0x50>
8010505a:	01 c3                	add    %eax,%ebx
8010505c:	39 da                	cmp    %ebx,%edx
8010505e:	72 10                	jb     80105070 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105060:	8b 55 0c             	mov    0xc(%ebp),%edx
80105063:	89 02                	mov    %eax,(%edx)
  return 0;
80105065:	31 c0                	xor    %eax,%eax
}
80105067:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010506a:	5b                   	pop    %ebx
8010506b:	5e                   	pop    %esi
8010506c:	5d                   	pop    %ebp
8010506d:	c3                   	ret    
8010506e:	66 90                	xchg   %ax,%ax
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105075:	eb f0                	jmp    80105067 <argptr+0x47>
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax

80105080 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010508a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508d:	50                   	push   %eax
8010508e:	ff 75 08             	pushl  0x8(%ebp)
80105091:	e8 3a ff ff ff       	call   80104fd0 <argint>
80105096:	83 c4 10             	add    $0x10,%esp
80105099:	85 c0                	test   %eax,%eax
8010509b:	78 13                	js     801050b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010509d:	83 ec 08             	sub    $0x8,%esp
801050a0:	ff 75 0c             	pushl  0xc(%ebp)
801050a3:	ff 75 f4             	pushl  -0xc(%ebp)
801050a6:	e8 c5 fe ff ff       	call   80104f70 <fetchstr>
801050ab:	83 c4 10             	add    $0x10,%esp
}
801050ae:	c9                   	leave  
801050af:	c3                   	ret    
801050b0:	c9                   	leave  
    return -1;
801050b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b6:	c3                   	ret    
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <syscall>:
[SYS_wtp]     sys_wtp,
};

void
syscall(void)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050cb:	e8 10 eb ff ff       	call   80103be0 <myproc>
801050d0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050d2:	8b 40 2c             	mov    0x2c(%eax),%eax
801050d5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801050db:	83 fa 18             	cmp    $0x18,%edx
801050de:	77 20                	ja     80105100 <syscall+0x40>
801050e0:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
801050e7:	85 d2                	test   %edx,%edx
801050e9:	74 15                	je     80105100 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801050eb:	ff d2                	call   *%edx
801050ed:	89 c2                	mov    %eax,%edx
801050ef:	8b 43 2c             	mov    0x2c(%ebx),%eax
801050f2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f8:	c9                   	leave  
801050f9:	c3                   	ret    
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105100:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105101:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105107:	50                   	push   %eax
80105108:	ff 73 24             	pushl  0x24(%ebx)
8010510b:	68 7d 7f 10 80       	push   $0x80107f7d
80105110:	e8 9b b5 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105115:	8b 43 2c             	mov    0x2c(%ebx),%eax
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105125:	c9                   	leave  
80105126:	c3                   	ret    
80105127:	66 90                	xchg   %ax,%ax
80105129:	66 90                	xchg   %ax,%ax
8010512b:	66 90                	xchg   %ax,%ax
8010512d:	66 90                	xchg   %ax,%ax
8010512f:	90                   	nop

80105130 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105135:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105138:	53                   	push   %ebx
80105139:	83 ec 34             	sub    $0x34,%esp
8010513c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010513f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105142:	57                   	push   %edi
80105143:	50                   	push   %eax
{
80105144:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105147:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010514a:	e8 11 cf ff ff       	call   80102060 <nameiparent>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 84 46 01 00 00    	je     801052a0 <create+0x170>
    return 0;
  ilock(dp);
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	89 c3                	mov    %eax,%ebx
8010515f:	50                   	push   %eax
80105160:	e8 0b c6 ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105165:	83 c4 0c             	add    $0xc,%esp
80105168:	6a 00                	push   $0x0
8010516a:	57                   	push   %edi
8010516b:	53                   	push   %ebx
8010516c:	e8 4f cb ff ff       	call   80101cc0 <dirlookup>
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	89 c6                	mov    %eax,%esi
80105176:	85 c0                	test   %eax,%eax
80105178:	74 56                	je     801051d0 <create+0xa0>
    iunlockput(dp);
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	53                   	push   %ebx
8010517e:	e8 8d c8 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105183:	89 34 24             	mov    %esi,(%esp)
80105186:	e8 e5 c5 ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010518b:	83 c4 10             	add    $0x10,%esp
8010518e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105193:	75 1b                	jne    801051b0 <create+0x80>
80105195:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010519a:	75 14                	jne    801051b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010519c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519f:	89 f0                	mov    %esi,%eax
801051a1:	5b                   	pop    %ebx
801051a2:	5e                   	pop    %esi
801051a3:	5f                   	pop    %edi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	56                   	push   %esi
    return 0;
801051b4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801051b6:	e8 55 c8 ff ff       	call   80101a10 <iunlockput>
    return 0;
801051bb:	83 c4 10             	add    $0x10,%esp
}
801051be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c1:	89 f0                	mov    %esi,%eax
801051c3:	5b                   	pop    %ebx
801051c4:	5e                   	pop    %esi
801051c5:	5f                   	pop    %edi
801051c6:	5d                   	pop    %ebp
801051c7:	c3                   	ret    
801051c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801051d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	50                   	push   %eax
801051d8:	ff 33                	pushl  (%ebx)
801051da:	e8 11 c4 ff ff       	call   801015f0 <ialloc>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	89 c6                	mov    %eax,%esi
801051e4:	85 c0                	test   %eax,%eax
801051e6:	0f 84 cd 00 00 00    	je     801052b9 <create+0x189>
  ilock(ip);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	50                   	push   %eax
801051f0:	e8 7b c5 ff ff       	call   80101770 <ilock>
  ip->major = major;
801051f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051f9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801051fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105201:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105205:	b8 01 00 00 00       	mov    $0x1,%eax
8010520a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010520e:	89 34 24             	mov    %esi,(%esp)
80105211:	e8 9a c4 ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010521e:	74 30                	je     80105250 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105220:	83 ec 04             	sub    $0x4,%esp
80105223:	ff 76 04             	pushl  0x4(%esi)
80105226:	57                   	push   %edi
80105227:	53                   	push   %ebx
80105228:	e8 53 cd ff ff       	call   80101f80 <dirlink>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	78 78                	js     801052ac <create+0x17c>
  iunlockput(dp);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	53                   	push   %ebx
80105238:	e8 d3 c7 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010523d:	83 c4 10             	add    $0x10,%esp
}
80105240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105243:	89 f0                	mov    %esi,%eax
80105245:	5b                   	pop    %ebx
80105246:	5e                   	pop    %esi
80105247:	5f                   	pop    %edi
80105248:	5d                   	pop    %ebp
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105250:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105253:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105258:	53                   	push   %ebx
80105259:	e8 52 c4 ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010525e:	83 c4 0c             	add    $0xc,%esp
80105261:	ff 76 04             	pushl  0x4(%esi)
80105264:	68 24 80 10 80       	push   $0x80108024
80105269:	56                   	push   %esi
8010526a:	e8 11 cd ff ff       	call   80101f80 <dirlink>
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	85 c0                	test   %eax,%eax
80105274:	78 18                	js     8010528e <create+0x15e>
80105276:	83 ec 04             	sub    $0x4,%esp
80105279:	ff 73 04             	pushl  0x4(%ebx)
8010527c:	68 23 80 10 80       	push   $0x80108023
80105281:	56                   	push   %esi
80105282:	e8 f9 cc ff ff       	call   80101f80 <dirlink>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	85 c0                	test   %eax,%eax
8010528c:	79 92                	jns    80105220 <create+0xf0>
      panic("create dots");
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	68 17 80 10 80       	push   $0x80108017
80105296:	e8 f5 b0 ff ff       	call   80100390 <panic>
8010529b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop
}
801052a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801052a3:	31 f6                	xor    %esi,%esi
}
801052a5:	5b                   	pop    %ebx
801052a6:	89 f0                	mov    %esi,%eax
801052a8:	5e                   	pop    %esi
801052a9:	5f                   	pop    %edi
801052aa:	5d                   	pop    %ebp
801052ab:	c3                   	ret    
    panic("create: dirlink");
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	68 26 80 10 80       	push   $0x80108026
801052b4:	e8 d7 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	68 08 80 10 80       	push   $0x80108008
801052c1:	e8 ca b0 ff ff       	call   80100390 <panic>
801052c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cd:	8d 76 00             	lea    0x0(%esi),%esi

801052d0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	89 d6                	mov    %edx,%esi
801052d6:	53                   	push   %ebx
801052d7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052df:	50                   	push   %eax
801052e0:	6a 00                	push   $0x0
801052e2:	e8 e9 fc ff ff       	call   80104fd0 <argint>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	85 c0                	test   %eax,%eax
801052ec:	78 2a                	js     80105318 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052f2:	77 24                	ja     80105318 <argfd.constprop.0+0x48>
801052f4:	e8 e7 e8 ff ff       	call   80103be0 <myproc>
801052f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052fc:	8b 44 90 3c          	mov    0x3c(%eax,%edx,4),%eax
80105300:	85 c0                	test   %eax,%eax
80105302:	74 14                	je     80105318 <argfd.constprop.0+0x48>
  if(pfd)
80105304:	85 db                	test   %ebx,%ebx
80105306:	74 02                	je     8010530a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105308:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010530a:	89 06                	mov    %eax,(%esi)
  return 0;
8010530c:	31 c0                	xor    %eax,%eax
}
8010530e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105311:	5b                   	pop    %ebx
80105312:	5e                   	pop    %esi
80105313:	5d                   	pop    %ebp
80105314:	c3                   	ret    
80105315:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531d:	eb ef                	jmp    8010530e <argfd.constprop.0+0x3e>
8010531f:	90                   	nop

80105320 <sys_dup>:
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105325:	31 c0                	xor    %eax,%eax
{
80105327:	89 e5                	mov    %esp,%ebp
80105329:	56                   	push   %esi
8010532a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010532b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010532e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105331:	e8 9a ff ff ff       	call   801052d0 <argfd.constprop.0>
80105336:	85 c0                	test   %eax,%eax
80105338:	78 1e                	js     80105358 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010533a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010533d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010533f:	e8 9c e8 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105348:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
8010534c:	85 d2                	test   %edx,%edx
8010534e:	74 20                	je     80105370 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105350:	83 c3 01             	add    $0x1,%ebx
80105353:	83 fb 10             	cmp    $0x10,%ebx
80105356:	75 f0                	jne    80105348 <sys_dup+0x28>
}
80105358:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010535b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105360:	89 d8                	mov    %ebx,%eax
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5d                   	pop    %ebp
80105365:	c3                   	ret    
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105370:	89 74 98 3c          	mov    %esi,0x3c(%eax,%ebx,4)
  filedup(f);
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	ff 75 f4             	pushl  -0xc(%ebp)
8010537a:	e8 01 bb ff ff       	call   80100e80 <filedup>
  return fd;
8010537f:	83 c4 10             	add    $0x10,%esp
}
80105382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105385:	89 d8                	mov    %ebx,%eax
80105387:	5b                   	pop    %ebx
80105388:	5e                   	pop    %esi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop

80105390 <sys_read>:
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105395:	31 c0                	xor    %eax,%eax
{
80105397:	89 e5                	mov    %esp,%ebp
80105399:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010539c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010539f:	e8 2c ff ff ff       	call   801052d0 <argfd.constprop.0>
801053a4:	85 c0                	test   %eax,%eax
801053a6:	78 48                	js     801053f0 <sys_read+0x60>
801053a8:	83 ec 08             	sub    $0x8,%esp
801053ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ae:	50                   	push   %eax
801053af:	6a 02                	push   $0x2
801053b1:	e8 1a fc ff ff       	call   80104fd0 <argint>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	78 33                	js     801053f0 <sys_read+0x60>
801053bd:	83 ec 04             	sub    $0x4,%esp
801053c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c3:	ff 75 f0             	pushl  -0x10(%ebp)
801053c6:	50                   	push   %eax
801053c7:	6a 01                	push   $0x1
801053c9:	e8 52 fc ff ff       	call   80105020 <argptr>
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 1b                	js     801053f0 <sys_read+0x60>
  return fileread(f, p, n);
801053d5:	83 ec 04             	sub    $0x4,%esp
801053d8:	ff 75 f0             	pushl  -0x10(%ebp)
801053db:	ff 75 f4             	pushl  -0xc(%ebp)
801053de:	ff 75 ec             	pushl  -0x14(%ebp)
801053e1:	e8 1a bc ff ff       	call   80101000 <fileread>
801053e6:	83 c4 10             	add    $0x10,%esp
}
801053e9:	c9                   	leave  
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
801053f0:	c9                   	leave  
    return -1;
801053f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f6:	c3                   	ret    
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax

80105400 <sys_write>:
{
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105405:	31 c0                	xor    %eax,%eax
{
80105407:	89 e5                	mov    %esp,%ebp
80105409:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010540c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010540f:	e8 bc fe ff ff       	call   801052d0 <argfd.constprop.0>
80105414:	85 c0                	test   %eax,%eax
80105416:	78 48                	js     80105460 <sys_write+0x60>
80105418:	83 ec 08             	sub    $0x8,%esp
8010541b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010541e:	50                   	push   %eax
8010541f:	6a 02                	push   $0x2
80105421:	e8 aa fb ff ff       	call   80104fd0 <argint>
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	85 c0                	test   %eax,%eax
8010542b:	78 33                	js     80105460 <sys_write+0x60>
8010542d:	83 ec 04             	sub    $0x4,%esp
80105430:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105433:	ff 75 f0             	pushl  -0x10(%ebp)
80105436:	50                   	push   %eax
80105437:	6a 01                	push   $0x1
80105439:	e8 e2 fb ff ff       	call   80105020 <argptr>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	85 c0                	test   %eax,%eax
80105443:	78 1b                	js     80105460 <sys_write+0x60>
  return filewrite(f, p, n);
80105445:	83 ec 04             	sub    $0x4,%esp
80105448:	ff 75 f0             	pushl  -0x10(%ebp)
8010544b:	ff 75 f4             	pushl  -0xc(%ebp)
8010544e:	ff 75 ec             	pushl  -0x14(%ebp)
80105451:	e8 4a bc ff ff       	call   801010a0 <filewrite>
80105456:	83 c4 10             	add    $0x10,%esp
}
80105459:	c9                   	leave  
8010545a:	c3                   	ret    
8010545b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
80105460:	c9                   	leave  
    return -1;
80105461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105466:	c3                   	ret    
80105467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546e:	66 90                	xchg   %ax,%ax

80105470 <sys_close>:
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010547a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010547d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105480:	e8 4b fe ff ff       	call   801052d0 <argfd.constprop.0>
80105485:	85 c0                	test   %eax,%eax
80105487:	78 27                	js     801054b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105489:	e8 52 e7 ff ff       	call   80103be0 <myproc>
8010548e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105491:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105494:	c7 44 90 3c 00 00 00 	movl   $0x0,0x3c(%eax,%edx,4)
8010549b:	00 
  fileclose(f);
8010549c:	ff 75 f4             	pushl  -0xc(%ebp)
8010549f:	e8 2c ba ff ff       	call   80100ed0 <fileclose>
  return 0;
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	31 c0                	xor    %eax,%eax
}
801054a9:	c9                   	leave  
801054aa:	c3                   	ret    
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop
801054b0:	c9                   	leave  
    return -1;
801054b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b6:	c3                   	ret    
801054b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054be:	66 90                	xchg   %ax,%ax

801054c0 <sys_fstat>:
{
801054c0:	f3 0f 1e fb          	endbr32 
801054c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054c5:	31 c0                	xor    %eax,%eax
{
801054c7:	89 e5                	mov    %esp,%ebp
801054c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054cc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054cf:	e8 fc fd ff ff       	call   801052d0 <argfd.constprop.0>
801054d4:	85 c0                	test   %eax,%eax
801054d6:	78 30                	js     80105508 <sys_fstat+0x48>
801054d8:	83 ec 04             	sub    $0x4,%esp
801054db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054de:	6a 14                	push   $0x14
801054e0:	50                   	push   %eax
801054e1:	6a 01                	push   $0x1
801054e3:	e8 38 fb ff ff       	call   80105020 <argptr>
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	85 c0                	test   %eax,%eax
801054ed:	78 19                	js     80105508 <sys_fstat+0x48>
  return filestat(f, st);
801054ef:	83 ec 08             	sub    $0x8,%esp
801054f2:	ff 75 f4             	pushl  -0xc(%ebp)
801054f5:	ff 75 f0             	pushl  -0x10(%ebp)
801054f8:	e8 b3 ba ff ff       	call   80100fb0 <filestat>
801054fd:	83 c4 10             	add    $0x10,%esp
}
80105500:	c9                   	leave  
80105501:	c3                   	ret    
80105502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105508:	c9                   	leave  
    return -1;
80105509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010550e:	c3                   	ret    
8010550f:	90                   	nop

80105510 <sys_link>:
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	57                   	push   %edi
80105518:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105519:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010551c:	53                   	push   %ebx
8010551d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105520:	50                   	push   %eax
80105521:	6a 00                	push   $0x0
80105523:	e8 58 fb ff ff       	call   80105080 <argstr>
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	85 c0                	test   %eax,%eax
8010552d:	0f 88 ff 00 00 00    	js     80105632 <sys_link+0x122>
80105533:	83 ec 08             	sub    $0x8,%esp
80105536:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105539:	50                   	push   %eax
8010553a:	6a 01                	push   $0x1
8010553c:	e8 3f fb ff ff       	call   80105080 <argstr>
80105541:	83 c4 10             	add    $0x10,%esp
80105544:	85 c0                	test   %eax,%eax
80105546:	0f 88 e6 00 00 00    	js     80105632 <sys_link+0x122>
  begin_op();
8010554c:	e8 ef d7 ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80105551:	83 ec 0c             	sub    $0xc,%esp
80105554:	ff 75 d4             	pushl  -0x2c(%ebp)
80105557:	e8 e4 ca ff ff       	call   80102040 <namei>
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	89 c3                	mov    %eax,%ebx
80105561:	85 c0                	test   %eax,%eax
80105563:	0f 84 e8 00 00 00    	je     80105651 <sys_link+0x141>
  ilock(ip);
80105569:	83 ec 0c             	sub    $0xc,%esp
8010556c:	50                   	push   %eax
8010556d:	e8 fe c1 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80105572:	83 c4 10             	add    $0x10,%esp
80105575:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010557a:	0f 84 b9 00 00 00    	je     80105639 <sys_link+0x129>
  iupdate(ip);
80105580:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105583:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105588:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010558b:	53                   	push   %ebx
8010558c:	e8 1f c1 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80105591:	89 1c 24             	mov    %ebx,(%esp)
80105594:	e8 b7 c2 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105599:	58                   	pop    %eax
8010559a:	5a                   	pop    %edx
8010559b:	57                   	push   %edi
8010559c:	ff 75 d0             	pushl  -0x30(%ebp)
8010559f:	e8 bc ca ff ff       	call   80102060 <nameiparent>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	89 c6                	mov    %eax,%esi
801055a9:	85 c0                	test   %eax,%eax
801055ab:	74 5f                	je     8010560c <sys_link+0xfc>
  ilock(dp);
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	50                   	push   %eax
801055b1:	e8 ba c1 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055b6:	8b 03                	mov    (%ebx),%eax
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	39 06                	cmp    %eax,(%esi)
801055bd:	75 41                	jne    80105600 <sys_link+0xf0>
801055bf:	83 ec 04             	sub    $0x4,%esp
801055c2:	ff 73 04             	pushl  0x4(%ebx)
801055c5:	57                   	push   %edi
801055c6:	56                   	push   %esi
801055c7:	e8 b4 c9 ff ff       	call   80101f80 <dirlink>
801055cc:	83 c4 10             	add    $0x10,%esp
801055cf:	85 c0                	test   %eax,%eax
801055d1:	78 2d                	js     80105600 <sys_link+0xf0>
  iunlockput(dp);
801055d3:	83 ec 0c             	sub    $0xc,%esp
801055d6:	56                   	push   %esi
801055d7:	e8 34 c4 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801055dc:	89 1c 24             	mov    %ebx,(%esp)
801055df:	e8 bc c2 ff ff       	call   801018a0 <iput>
  end_op();
801055e4:	e8 c7 d7 ff ff       	call   80102db0 <end_op>
  return 0;
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	31 c0                	xor    %eax,%eax
}
801055ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f1:	5b                   	pop    %ebx
801055f2:	5e                   	pop    %esi
801055f3:	5f                   	pop    %edi
801055f4:	5d                   	pop    %ebp
801055f5:	c3                   	ret    
801055f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	56                   	push   %esi
80105604:	e8 07 c4 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105609:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	53                   	push   %ebx
80105610:	e8 5b c1 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105615:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010561a:	89 1c 24             	mov    %ebx,(%esp)
8010561d:	e8 8e c0 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105622:	89 1c 24             	mov    %ebx,(%esp)
80105625:	e8 e6 c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010562a:	e8 81 d7 ff ff       	call   80102db0 <end_op>
  return -1;
8010562f:	83 c4 10             	add    $0x10,%esp
80105632:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105637:	eb b5                	jmp    801055ee <sys_link+0xde>
    iunlockput(ip);
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	53                   	push   %ebx
8010563d:	e8 ce c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105642:	e8 69 d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105647:	83 c4 10             	add    $0x10,%esp
8010564a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010564f:	eb 9d                	jmp    801055ee <sys_link+0xde>
    end_op();
80105651:	e8 5a d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105656:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565b:	eb 91                	jmp    801055ee <sys_link+0xde>
8010565d:	8d 76 00             	lea    0x0(%esi),%esi

80105660 <sys_unlink>:
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	57                   	push   %edi
80105668:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105669:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010566c:	53                   	push   %ebx
8010566d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105670:	50                   	push   %eax
80105671:	6a 00                	push   $0x0
80105673:	e8 08 fa ff ff       	call   80105080 <argstr>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	85 c0                	test   %eax,%eax
8010567d:	0f 88 7d 01 00 00    	js     80105800 <sys_unlink+0x1a0>
  begin_op();
80105683:	e8 b8 d6 ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105688:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010568b:	83 ec 08             	sub    $0x8,%esp
8010568e:	53                   	push   %ebx
8010568f:	ff 75 c0             	pushl  -0x40(%ebp)
80105692:	e8 c9 c9 ff ff       	call   80102060 <nameiparent>
80105697:	83 c4 10             	add    $0x10,%esp
8010569a:	89 c6                	mov    %eax,%esi
8010569c:	85 c0                	test   %eax,%eax
8010569e:	0f 84 66 01 00 00    	je     8010580a <sys_unlink+0x1aa>
  ilock(dp);
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	50                   	push   %eax
801056a8:	e8 c3 c0 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056ad:	58                   	pop    %eax
801056ae:	5a                   	pop    %edx
801056af:	68 24 80 10 80       	push   $0x80108024
801056b4:	53                   	push   %ebx
801056b5:	e8 e6 c5 ff ff       	call   80101ca0 <namecmp>
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	85 c0                	test   %eax,%eax
801056bf:	0f 84 03 01 00 00    	je     801057c8 <sys_unlink+0x168>
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	68 23 80 10 80       	push   $0x80108023
801056cd:	53                   	push   %ebx
801056ce:	e8 cd c5 ff ff       	call   80101ca0 <namecmp>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	0f 84 ea 00 00 00    	je     801057c8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056de:	83 ec 04             	sub    $0x4,%esp
801056e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056e4:	50                   	push   %eax
801056e5:	53                   	push   %ebx
801056e6:	56                   	push   %esi
801056e7:	e8 d4 c5 ff ff       	call   80101cc0 <dirlookup>
801056ec:	83 c4 10             	add    $0x10,%esp
801056ef:	89 c3                	mov    %eax,%ebx
801056f1:	85 c0                	test   %eax,%eax
801056f3:	0f 84 cf 00 00 00    	je     801057c8 <sys_unlink+0x168>
  ilock(ip);
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	50                   	push   %eax
801056fd:	e8 6e c0 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010570a:	0f 8e 23 01 00 00    	jle    80105833 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105710:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105715:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105718:	74 66                	je     80105780 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010571a:	83 ec 04             	sub    $0x4,%esp
8010571d:	6a 10                	push   $0x10
8010571f:	6a 00                	push   $0x0
80105721:	57                   	push   %edi
80105722:	e8 c9 f5 ff ff       	call   80104cf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105727:	6a 10                	push   $0x10
80105729:	ff 75 c4             	pushl  -0x3c(%ebp)
8010572c:	57                   	push   %edi
8010572d:	56                   	push   %esi
8010572e:	e8 3d c4 ff ff       	call   80101b70 <writei>
80105733:	83 c4 20             	add    $0x20,%esp
80105736:	83 f8 10             	cmp    $0x10,%eax
80105739:	0f 85 e7 00 00 00    	jne    80105826 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010573f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105744:	0f 84 96 00 00 00    	je     801057e0 <sys_unlink+0x180>
  iunlockput(dp);
8010574a:	83 ec 0c             	sub    $0xc,%esp
8010574d:	56                   	push   %esi
8010574e:	e8 bd c2 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105753:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105758:	89 1c 24             	mov    %ebx,(%esp)
8010575b:	e8 50 bf ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105760:	89 1c 24             	mov    %ebx,(%esp)
80105763:	e8 a8 c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105768:	e8 43 d6 ff ff       	call   80102db0 <end_op>
  return 0;
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	31 c0                	xor    %eax,%eax
}
80105772:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105775:	5b                   	pop    %ebx
80105776:	5e                   	pop    %esi
80105777:	5f                   	pop    %edi
80105778:	5d                   	pop    %ebp
80105779:	c3                   	ret    
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105780:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105784:	76 94                	jbe    8010571a <sys_unlink+0xba>
80105786:	ba 20 00 00 00       	mov    $0x20,%edx
8010578b:	eb 0b                	jmp    80105798 <sys_unlink+0x138>
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
80105790:	83 c2 10             	add    $0x10,%edx
80105793:	39 53 58             	cmp    %edx,0x58(%ebx)
80105796:	76 82                	jbe    8010571a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105798:	6a 10                	push   $0x10
8010579a:	52                   	push   %edx
8010579b:	57                   	push   %edi
8010579c:	53                   	push   %ebx
8010579d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801057a0:	e8 cb c2 ff ff       	call   80101a70 <readi>
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801057ab:	83 f8 10             	cmp    $0x10,%eax
801057ae:	75 69                	jne    80105819 <sys_unlink+0x1b9>
    if(de.inum != 0)
801057b0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057b5:	74 d9                	je     80105790 <sys_unlink+0x130>
    iunlockput(ip);
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	53                   	push   %ebx
801057bb:	e8 50 c2 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801057c0:	83 c4 10             	add    $0x10,%esp
801057c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057c7:	90                   	nop
  iunlockput(dp);
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	56                   	push   %esi
801057cc:	e8 3f c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057d1:	e8 da d5 ff ff       	call   80102db0 <end_op>
  return -1;
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057de:	eb 92                	jmp    80105772 <sys_unlink+0x112>
    iupdate(dp);
801057e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801057e3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801057e8:	56                   	push   %esi
801057e9:	e8 c2 be ff ff       	call   801016b0 <iupdate>
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	e9 54 ff ff ff       	jmp    8010574a <sys_unlink+0xea>
801057f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105805:	e9 68 ff ff ff       	jmp    80105772 <sys_unlink+0x112>
    end_op();
8010580a:	e8 a1 d5 ff ff       	call   80102db0 <end_op>
    return -1;
8010580f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105814:	e9 59 ff ff ff       	jmp    80105772 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105819:	83 ec 0c             	sub    $0xc,%esp
8010581c:	68 48 80 10 80       	push   $0x80108048
80105821:	e8 6a ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105826:	83 ec 0c             	sub    $0xc,%esp
80105829:	68 5a 80 10 80       	push   $0x8010805a
8010582e:	e8 5d ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105833:	83 ec 0c             	sub    $0xc,%esp
80105836:	68 36 80 10 80       	push   $0x80108036
8010583b:	e8 50 ab ff ff       	call   80100390 <panic>

80105840 <sys_open>:

int
sys_open(void)
{
80105840:	f3 0f 1e fb          	endbr32 
80105844:	55                   	push   %ebp
80105845:	89 e5                	mov    %esp,%ebp
80105847:	57                   	push   %edi
80105848:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105849:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010584c:	53                   	push   %ebx
8010584d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105850:	50                   	push   %eax
80105851:	6a 00                	push   $0x0
80105853:	e8 28 f8 ff ff       	call   80105080 <argstr>
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	85 c0                	test   %eax,%eax
8010585d:	0f 88 8a 00 00 00    	js     801058ed <sys_open+0xad>
80105863:	83 ec 08             	sub    $0x8,%esp
80105866:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105869:	50                   	push   %eax
8010586a:	6a 01                	push   $0x1
8010586c:	e8 5f f7 ff ff       	call   80104fd0 <argint>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	85 c0                	test   %eax,%eax
80105876:	78 75                	js     801058ed <sys_open+0xad>
    return -1;

  begin_op();
80105878:	e8 c3 d4 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010587d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105881:	75 75                	jne    801058f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105883:	83 ec 0c             	sub    $0xc,%esp
80105886:	ff 75 e0             	pushl  -0x20(%ebp)
80105889:	e8 b2 c7 ff ff       	call   80102040 <namei>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	89 c6                	mov    %eax,%esi
80105893:	85 c0                	test   %eax,%eax
80105895:	74 7e                	je     80105915 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105897:	83 ec 0c             	sub    $0xc,%esp
8010589a:	50                   	push   %eax
8010589b:	e8 d0 be ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058a0:	83 c4 10             	add    $0x10,%esp
801058a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058a8:	0f 84 c2 00 00 00    	je     80105970 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058ae:	e8 5d b5 ff ff       	call   80100e10 <filealloc>
801058b3:	89 c7                	mov    %eax,%edi
801058b5:	85 c0                	test   %eax,%eax
801058b7:	74 23                	je     801058dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801058b9:	e8 22 e3 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801058c0:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
801058c4:	85 d2                	test   %edx,%edx
801058c6:	74 60                	je     80105928 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801058c8:	83 c3 01             	add    $0x1,%ebx
801058cb:	83 fb 10             	cmp    $0x10,%ebx
801058ce:	75 f0                	jne    801058c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	57                   	push   %edi
801058d4:	e8 f7 b5 ff ff       	call   80100ed0 <fileclose>
801058d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801058dc:	83 ec 0c             	sub    $0xc,%esp
801058df:	56                   	push   %esi
801058e0:	e8 2b c1 ff ff       	call   80101a10 <iunlockput>
    end_op();
801058e5:	e8 c6 d4 ff ff       	call   80102db0 <end_op>
    return -1;
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058f2:	eb 6d                	jmp    80105961 <sys_open+0x121>
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801058f8:	83 ec 0c             	sub    $0xc,%esp
801058fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801058fe:	31 c9                	xor    %ecx,%ecx
80105900:	ba 02 00 00 00       	mov    $0x2,%edx
80105905:	6a 00                	push   $0x0
80105907:	e8 24 f8 ff ff       	call   80105130 <create>
    if(ip == 0){
8010590c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010590f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105911:	85 c0                	test   %eax,%eax
80105913:	75 99                	jne    801058ae <sys_open+0x6e>
      end_op();
80105915:	e8 96 d4 ff ff       	call   80102db0 <end_op>
      return -1;
8010591a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010591f:	eb 40                	jmp    80105961 <sys_open+0x121>
80105921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105928:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010592b:	89 7c 98 3c          	mov    %edi,0x3c(%eax,%ebx,4)
  iunlock(ip);
8010592f:	56                   	push   %esi
80105930:	e8 1b bf ff ff       	call   80101850 <iunlock>
  end_op();
80105935:	e8 76 d4 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
8010593a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105940:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105943:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105946:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105949:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010594b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105952:	f7 d0                	not    %eax
80105954:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105957:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010595a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010595d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105964:	89 d8                	mov    %ebx,%eax
80105966:	5b                   	pop    %ebx
80105967:	5e                   	pop    %esi
80105968:	5f                   	pop    %edi
80105969:	5d                   	pop    %ebp
8010596a:	c3                   	ret    
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105970:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105973:	85 c9                	test   %ecx,%ecx
80105975:	0f 84 33 ff ff ff    	je     801058ae <sys_open+0x6e>
8010597b:	e9 5c ff ff ff       	jmp    801058dc <sys_open+0x9c>

80105980 <sys_mkdir>:

int
sys_mkdir(void)
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
80105985:	89 e5                	mov    %esp,%ebp
80105987:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010598a:	e8 b1 d3 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010598f:	83 ec 08             	sub    $0x8,%esp
80105992:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105995:	50                   	push   %eax
80105996:	6a 00                	push   $0x0
80105998:	e8 e3 f6 ff ff       	call   80105080 <argstr>
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	85 c0                	test   %eax,%eax
801059a2:	78 34                	js     801059d8 <sys_mkdir+0x58>
801059a4:	83 ec 0c             	sub    $0xc,%esp
801059a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059aa:	31 c9                	xor    %ecx,%ecx
801059ac:	ba 01 00 00 00       	mov    $0x1,%edx
801059b1:	6a 00                	push   $0x0
801059b3:	e8 78 f7 ff ff       	call   80105130 <create>
801059b8:	83 c4 10             	add    $0x10,%esp
801059bb:	85 c0                	test   %eax,%eax
801059bd:	74 19                	je     801059d8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	50                   	push   %eax
801059c3:	e8 48 c0 ff ff       	call   80101a10 <iunlockput>
  end_op();
801059c8:	e8 e3 d3 ff ff       	call   80102db0 <end_op>
  return 0;
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	31 c0                	xor    %eax,%eax
}
801059d2:	c9                   	leave  
801059d3:	c3                   	ret    
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059d8:	e8 d3 d3 ff ff       	call   80102db0 <end_op>
    return -1;
801059dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e2:	c9                   	leave  
801059e3:	c3                   	ret    
801059e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop

801059f0 <sys_mknod>:

int
sys_mknod(void)
{
801059f0:	f3 0f 1e fb          	endbr32 
801059f4:	55                   	push   %ebp
801059f5:	89 e5                	mov    %esp,%ebp
801059f7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059fa:	e8 41 d3 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059ff:	83 ec 08             	sub    $0x8,%esp
80105a02:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a05:	50                   	push   %eax
80105a06:	6a 00                	push   $0x0
80105a08:	e8 73 f6 ff ff       	call   80105080 <argstr>
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	85 c0                	test   %eax,%eax
80105a12:	78 64                	js     80105a78 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105a14:	83 ec 08             	sub    $0x8,%esp
80105a17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a1a:	50                   	push   %eax
80105a1b:	6a 01                	push   $0x1
80105a1d:	e8 ae f5 ff ff       	call   80104fd0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	78 4f                	js     80105a78 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105a29:	83 ec 08             	sub    $0x8,%esp
80105a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a2f:	50                   	push   %eax
80105a30:	6a 02                	push   $0x2
80105a32:	e8 99 f5 ff ff       	call   80104fd0 <argint>
     argint(1, &major) < 0 ||
80105a37:	83 c4 10             	add    $0x10,%esp
80105a3a:	85 c0                	test   %eax,%eax
80105a3c:	78 3a                	js     80105a78 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a3e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a42:	83 ec 0c             	sub    $0xc,%esp
80105a45:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a49:	ba 03 00 00 00       	mov    $0x3,%edx
80105a4e:	50                   	push   %eax
80105a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a52:	e8 d9 f6 ff ff       	call   80105130 <create>
     argint(2, &minor) < 0 ||
80105a57:	83 c4 10             	add    $0x10,%esp
80105a5a:	85 c0                	test   %eax,%eax
80105a5c:	74 1a                	je     80105a78 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a5e:	83 ec 0c             	sub    $0xc,%esp
80105a61:	50                   	push   %eax
80105a62:	e8 a9 bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a67:	e8 44 d3 ff ff       	call   80102db0 <end_op>
  return 0;
80105a6c:	83 c4 10             	add    $0x10,%esp
80105a6f:	31 c0                	xor    %eax,%eax
}
80105a71:	c9                   	leave  
80105a72:	c3                   	ret    
80105a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a77:	90                   	nop
    end_op();
80105a78:	e8 33 d3 ff ff       	call   80102db0 <end_op>
    return -1;
80105a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    
80105a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop

80105a90 <sys_chdir>:

int
sys_chdir(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	56                   	push   %esi
80105a98:	53                   	push   %ebx
80105a99:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a9c:	e8 3f e1 ff ff       	call   80103be0 <myproc>
80105aa1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105aa3:	e8 98 d2 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105aa8:	83 ec 08             	sub    $0x8,%esp
80105aab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aae:	50                   	push   %eax
80105aaf:	6a 00                	push   $0x0
80105ab1:	e8 ca f5 ff ff       	call   80105080 <argstr>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	78 73                	js     80105b30 <sys_chdir+0xa0>
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac3:	e8 78 c5 ff ff       	call   80102040 <namei>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	89 c3                	mov    %eax,%ebx
80105acd:	85 c0                	test   %eax,%eax
80105acf:	74 5f                	je     80105b30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ad1:	83 ec 0c             	sub    $0xc,%esp
80105ad4:	50                   	push   %eax
80105ad5:	e8 96 bc ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ae2:	75 2c                	jne    80105b10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ae4:	83 ec 0c             	sub    $0xc,%esp
80105ae7:	53                   	push   %ebx
80105ae8:	e8 63 bd ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
80105aed:	58                   	pop    %eax
80105aee:	ff 76 7c             	pushl  0x7c(%esi)
80105af1:	e8 aa bd ff ff       	call   801018a0 <iput>
  end_op();
80105af6:	e8 b5 d2 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105afb:	89 5e 7c             	mov    %ebx,0x7c(%esi)
  return 0;
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	31 c0                	xor    %eax,%eax
}
80105b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b06:	5b                   	pop    %ebx
80105b07:	5e                   	pop    %esi
80105b08:	5d                   	pop    %ebp
80105b09:	c3                   	ret    
80105b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	53                   	push   %ebx
80105b14:	e8 f7 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b19:	e8 92 d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b26:	eb db                	jmp    80105b03 <sys_chdir+0x73>
80105b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop
    end_op();
80105b30:	e8 7b d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3a:	eb c7                	jmp    80105b03 <sys_chdir+0x73>
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_exec>:

int
sys_exec(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	57                   	push   %edi
80105b48:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b49:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b4f:	53                   	push   %ebx
80105b50:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b56:	50                   	push   %eax
80105b57:	6a 00                	push   $0x0
80105b59:	e8 22 f5 ff ff       	call   80105080 <argstr>
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	85 c0                	test   %eax,%eax
80105b63:	0f 88 8b 00 00 00    	js     80105bf4 <sys_exec+0xb4>
80105b69:	83 ec 08             	sub    $0x8,%esp
80105b6c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b72:	50                   	push   %eax
80105b73:	6a 01                	push   $0x1
80105b75:	e8 56 f4 ff ff       	call   80104fd0 <argint>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	78 73                	js     80105bf4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b81:	83 ec 04             	sub    $0x4,%esp
80105b84:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105b8a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b8c:	68 80 00 00 00       	push   $0x80
80105b91:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b97:	6a 00                	push   $0x0
80105b99:	50                   	push   %eax
80105b9a:	e8 51 f1 ff ff       	call   80104cf0 <memset>
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ba8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bae:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bb5:	83 ec 08             	sub    $0x8,%esp
80105bb8:	57                   	push   %edi
80105bb9:	01 f0                	add    %esi,%eax
80105bbb:	50                   	push   %eax
80105bbc:	e8 6f f3 ff ff       	call   80104f30 <fetchint>
80105bc1:	83 c4 10             	add    $0x10,%esp
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	78 2c                	js     80105bf4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105bc8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bce:	85 c0                	test   %eax,%eax
80105bd0:	74 36                	je     80105c08 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bd2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bd8:	83 ec 08             	sub    $0x8,%esp
80105bdb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bde:	52                   	push   %edx
80105bdf:	50                   	push   %eax
80105be0:	e8 8b f3 ff ff       	call   80104f70 <fetchstr>
80105be5:	83 c4 10             	add    $0x10,%esp
80105be8:	85 c0                	test   %eax,%eax
80105bea:	78 08                	js     80105bf4 <sys_exec+0xb4>
  for(i=0;; i++){
80105bec:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105bef:	83 fb 20             	cmp    $0x20,%ebx
80105bf2:	75 b4                	jne    80105ba8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bfc:	5b                   	pop    %ebx
80105bfd:	5e                   	pop    %esi
80105bfe:	5f                   	pop    %edi
80105bff:	5d                   	pop    %ebp
80105c00:	c3                   	ret    
80105c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c08:	83 ec 08             	sub    $0x8,%esp
80105c0b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105c11:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c18:	00 00 00 00 
  return exec(path, argv);
80105c1c:	50                   	push   %eax
80105c1d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c23:	e8 58 ae ff ff       	call   80100a80 <exec>
80105c28:	83 c4 10             	add    $0x10,%esp
}
80105c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c2e:	5b                   	pop    %ebx
80105c2f:	5e                   	pop    %esi
80105c30:	5f                   	pop    %edi
80105c31:	5d                   	pop    %ebp
80105c32:	c3                   	ret    
80105c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c40 <sys_pipe>:

int
sys_pipe(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	57                   	push   %edi
80105c48:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c49:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c4c:	53                   	push   %ebx
80105c4d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c50:	6a 08                	push   $0x8
80105c52:	50                   	push   %eax
80105c53:	6a 00                	push   $0x0
80105c55:	e8 c6 f3 ff ff       	call   80105020 <argptr>
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	78 4e                	js     80105caf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c61:	83 ec 08             	sub    $0x8,%esp
80105c64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c67:	50                   	push   %eax
80105c68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c6b:	50                   	push   %eax
80105c6c:	e8 8f d7 ff ff       	call   80103400 <pipealloc>
80105c71:	83 c4 10             	add    $0x10,%esp
80105c74:	85 c0                	test   %eax,%eax
80105c76:	78 37                	js     80105caf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c78:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c7b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c7d:	e8 5e df ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105c88:	8b 74 98 3c          	mov    0x3c(%eax,%ebx,4),%esi
80105c8c:	85 f6                	test   %esi,%esi
80105c8e:	74 30                	je     80105cc0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105c90:	83 c3 01             	add    $0x1,%ebx
80105c93:	83 fb 10             	cmp    $0x10,%ebx
80105c96:	75 f0                	jne    80105c88 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c9e:	e8 2d b2 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105ca3:	58                   	pop    %eax
80105ca4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ca7:	e8 24 b2 ff ff       	call   80100ed0 <fileclose>
    return -1;
80105cac:	83 c4 10             	add    $0x10,%esp
80105caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb4:	eb 5b                	jmp    80105d11 <sys_pipe+0xd1>
80105cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105cc0:	8d 73 0c             	lea    0xc(%ebx),%esi
80105cc3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cca:	e8 11 df ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ccf:	31 d2                	xor    %edx,%edx
80105cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105cd8:	8b 4c 90 3c          	mov    0x3c(%eax,%edx,4),%ecx
80105cdc:	85 c9                	test   %ecx,%ecx
80105cde:	74 20                	je     80105d00 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ce0:	83 c2 01             	add    $0x1,%edx
80105ce3:	83 fa 10             	cmp    $0x10,%edx
80105ce6:	75 f0                	jne    80105cd8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ce8:	e8 f3 de ff ff       	call   80103be0 <myproc>
80105ced:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105cf4:	00 
80105cf5:	eb a1                	jmp    80105c98 <sys_pipe+0x58>
80105cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d00:	89 7c 90 3c          	mov    %edi,0x3c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d0f:	31 c0                	xor    %eax,%eax
}
80105d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d14:	5b                   	pop    %ebx
80105d15:	5e                   	pop    %esi
80105d16:	5f                   	pop    %edi
80105d17:	5d                   	pop    %ebp
80105d18:	c3                   	ret    
80105d19:	66 90                	xchg   %ax,%ax
80105d1b:	66 90                	xchg   %ax,%ax
80105d1d:	66 90                	xchg   %ax,%ax
80105d1f:	90                   	nop

80105d20 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d20:	f3 0f 1e fb          	endbr32 
  return fork();
80105d24:	e9 67 e0 ff ff       	jmp    80103d90 <fork>
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_exit>:
}

int
sys_exit(void)
{
80105d30:	f3 0f 1e fb          	endbr32 
80105d34:	55                   	push   %ebp
80105d35:	89 e5                	mov    %esp,%ebp
80105d37:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d3a:	e8 d1 e4 ff ff       	call   80104210 <exit>
  return 0;  // not reached
}
80105d3f:	31 c0                	xor    %eax,%eax
80105d41:	c9                   	leave  
80105d42:	c3                   	ret    
80105d43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d50 <sys_wait>:

int
sys_wait(void)
{
80105d50:	f3 0f 1e fb          	endbr32 
  return wait();
80105d54:	e9 07 e7 ff ff       	jmp    80104460 <wait>
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_kill>:
}

int
sys_kill(void)
{
80105d60:	f3 0f 1e fb          	endbr32 
80105d64:	55                   	push   %ebp
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d6d:	50                   	push   %eax
80105d6e:	6a 00                	push   $0x0
80105d70:	e8 5b f2 ff ff       	call   80104fd0 <argint>
80105d75:	83 c4 10             	add    $0x10,%esp
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	78 14                	js     80105d90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d7c:	83 ec 0c             	sub    $0xc,%esp
80105d7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d82:	e8 59 e8 ff ff       	call   801045e0 <kill>
80105d87:	83 c4 10             	add    $0x10,%esp
}
80105d8a:	c9                   	leave  
80105d8b:	c3                   	ret    
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d90:	c9                   	leave  
    return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d96:	c3                   	ret    
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <sys_getpid>:

int
sys_getpid(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105daa:	e8 31 de ff ff       	call   80103be0 <myproc>
80105daf:	8b 40 24             	mov    0x24(%eax),%eax
}
80105db2:	c9                   	leave  
80105db3:	c3                   	ret    
80105db4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dbf:	90                   	nop

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dcb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dce:	50                   	push   %eax
80105dcf:	6a 00                	push   $0x0
80105dd1:	e8 fa f1 ff ff       	call   80104fd0 <argint>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	78 23                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ddd:	e8 fe dd ff ff       	call   80103be0 <myproc>
  if(growproc(n) < 0)
80105de2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105de5:	8b 58 14             	mov    0x14(%eax),%ebx
  if(growproc(n) < 0)
80105de8:	ff 75 f4             	pushl  -0xc(%ebp)
80105deb:	e8 20 df ff ff       	call   80103d10 <growproc>
80105df0:	83 c4 10             	add    $0x10,%esp
80105df3:	85 c0                	test   %eax,%eax
80105df5:	78 09                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105df7:	89 d8                	mov    %ebx,%eax
80105df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dfc:	c9                   	leave  
80105dfd:	c3                   	ret    
80105dfe:	66 90                	xchg   %ax,%ax
    return -1;
80105e00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e05:	eb f0                	jmp    80105df7 <sys_sbrk+0x37>
80105e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <sys_sleep>:

int
sys_sleep(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e1b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e1e:	50                   	push   %eax
80105e1f:	6a 00                	push   $0x0
80105e21:	e8 aa f1 ff ff       	call   80104fd0 <argint>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	0f 88 86 00 00 00    	js     80105eb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e31:	83 ec 0c             	sub    $0xc,%esp
80105e34:	68 80 a6 11 80       	push   $0x8011a680
80105e39:	e8 a2 ed ff ff       	call   80104be0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e41:	8b 1d c0 ae 11 80    	mov    0x8011aec0,%ebx
  while(ticks - ticks0 < n){
80105e47:	83 c4 10             	add    $0x10,%esp
80105e4a:	85 d2                	test   %edx,%edx
80105e4c:	75 23                	jne    80105e71 <sys_sleep+0x61>
80105e4e:	eb 50                	jmp    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	68 80 a6 11 80       	push   $0x8011a680
80105e58:	68 c0 ae 11 80       	push   $0x8011aec0
80105e5d:	e8 3e e5 ff ff       	call   801043a0 <sleep>
  while(ticks - ticks0 < n){
80105e62:	a1 c0 ae 11 80       	mov    0x8011aec0,%eax
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	29 d8                	sub    %ebx,%eax
80105e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e6f:	73 2f                	jae    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e71:	e8 6a dd ff ff       	call   80103be0 <myproc>
80105e76:	8b 40 38             	mov    0x38(%eax),%eax
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 d3                	je     80105e50 <sys_sleep+0x40>
      release(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 80 a6 11 80       	push   $0x8011a680
80105e85:	e8 16 ee ff ff       	call   80104ca0 <release>
  }
  release(&tickslock);
  return 0;
}
80105e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 80 a6 11 80       	push   $0x8011a680
80105ea8:	e8 f3 ed ff ff       	call   80104ca0 <release>
  return 0;
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	31 c0                	xor    %eax,%eax
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	eb f4                	jmp    80105eb2 <sys_sleep+0xa2>
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	53                   	push   %ebx
80105ec8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ecb:	68 80 a6 11 80       	push   $0x8011a680
80105ed0:	e8 0b ed ff ff       	call   80104be0 <acquire>
  xticks = ticks;
80105ed5:	8b 1d c0 ae 11 80    	mov    0x8011aec0,%ebx
  release(&tickslock);
80105edb:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
80105ee2:	e8 b9 ed ff ff       	call   80104ca0 <release>
  return xticks;
}
80105ee7:	89 d8                	mov    %ebx,%eax
80105ee9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eec:	c9                   	leave  
80105eed:	c3                   	ret    
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_prio>:

int sys_prio(void){
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->prio;
80105efa:	e8 e1 dc ff ff       	call   80103be0 <myproc>
80105eff:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f02:	c9                   	leave  
80105f03:	c3                   	ret    
80105f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f0f:	90                   	nop

80105f10 <sys_cps>:

int sys_cps(void){
80105f10:	f3 0f 1e fb          	endbr32 
  return cps();
80105f14:	e9 37 e8 ff ff       	jmp    80104750 <cps>
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_chpr>:
}

int sys_chpr(void){
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0) return -1;
80105f2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f2d:	50                   	push   %eax
80105f2e:	6a 00                	push   $0x0
80105f30:	e8 9b f0 ff ff       	call   80104fd0 <argint>
80105f35:	83 c4 10             	add    $0x10,%esp
80105f38:	85 c0                	test   %eax,%eax
80105f3a:	78 2c                	js     80105f68 <sys_chpr+0x48>
  if(argint(0, &pr) < 0) return -1;
80105f3c:	83 ec 08             	sub    $0x8,%esp
80105f3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f42:	50                   	push   %eax
80105f43:	6a 00                	push   $0x0
80105f45:	e8 86 f0 ff ff       	call   80104fd0 <argint>
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	85 c0                	test   %eax,%eax
80105f4f:	78 17                	js     80105f68 <sys_chpr+0x48>

  return chpr(pid, pr);
80105f51:	83 ec 08             	sub    $0x8,%esp
80105f54:	ff 75 f4             	pushl  -0xc(%ebp)
80105f57:	ff 75 f0             	pushl  -0x10(%ebp)
80105f5a:	e8 f1 e8 ff ff       	call   80104850 <chpr>
80105f5f:	83 c4 10             	add    $0x10,%esp
}
80105f62:	c9                   	leave  
80105f63:	c3                   	ret    
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f68:	c9                   	leave  
  if(argint(0, &pid) < 0) return -1;
80105f69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f6e:	c3                   	ret    
80105f6f:	90                   	nop

80105f70 <sys_wtp>:

int sys_wtp(void){
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0) return -1;
80105f7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f7d:	50                   	push   %eax
80105f7e:	6a 00                	push   $0x0
80105f80:	e8 4b f0 ff ff       	call   80104fd0 <argint>
80105f85:	83 c4 10             	add    $0x10,%esp
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	78 24                	js     80105fb0 <sys_wtp+0x40>
  cprintf("process number %d\n", pid);
80105f8c:	83 ec 08             	sub    $0x8,%esp
80105f8f:	ff 75 f4             	pushl  -0xc(%ebp)
80105f92:	68 69 80 10 80       	push   $0x80108069
80105f97:	e8 14 a7 ff ff       	call   801006b0 <cprintf>
  withput_ticket_proc(pid);
80105f9c:	58                   	pop    %eax
80105f9d:	ff 75 f4             	pushl  -0xc(%ebp)
80105fa0:	e8 2b e9 ff ff       	call   801048d0 <withput_ticket_proc>
  return 0;
80105fa5:	83 c4 10             	add    $0x10,%esp
80105fa8:	31 c0                	xor    %eax,%eax
80105faa:	c9                   	leave  
80105fab:	c3                   	ret    
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fb0:	c9                   	leave  
  if(argint(0, &pid) < 0) return -1;
80105fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb6:	c3                   	ret    

80105fb7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fb7:	1e                   	push   %ds
  pushl %es
80105fb8:	06                   	push   %es
  pushl %fs
80105fb9:	0f a0                	push   %fs
  pushl %gs
80105fbb:	0f a8                	push   %gs
  pushal
80105fbd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fbe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fc2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fc4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fc6:	54                   	push   %esp
  call trap
80105fc7:	e8 c4 00 00 00       	call   80106090 <trap>
  addl $4, %esp
80105fcc:	83 c4 04             	add    $0x4,%esp

80105fcf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fcf:	61                   	popa   
  popl %gs
80105fd0:	0f a9                	pop    %gs
  popl %fs
80105fd2:	0f a1                	pop    %fs
  popl %es
80105fd4:	07                   	pop    %es
  popl %ds
80105fd5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fd6:	83 c4 08             	add    $0x8,%esp
  iret
80105fd9:	cf                   	iret   
80105fda:	66 90                	xchg   %ax,%ax
80105fdc:	66 90                	xchg   %ax,%ax
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105fe5:	31 c0                	xor    %eax,%eax
{
80105fe7:	89 e5                	mov    %esp,%ebp
80105fe9:	83 ec 08             	sub    $0x8,%esp
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ff0:	8b 14 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%edx
80105ff7:	c7 04 c5 c2 a6 11 80 	movl   $0x8e000008,-0x7fee593e(,%eax,8)
80105ffe:	08 00 00 8e 
80106002:	66 89 14 c5 c0 a6 11 	mov    %dx,-0x7fee5940(,%eax,8)
80106009:	80 
8010600a:	c1 ea 10             	shr    $0x10,%edx
8010600d:	66 89 14 c5 c6 a6 11 	mov    %dx,-0x7fee593a(,%eax,8)
80106014:	80 
  for(i = 0; i < 256; i++)
80106015:	83 c0 01             	add    $0x1,%eax
80106018:	3d 00 01 00 00       	cmp    $0x100,%eax
8010601d:	75 d1                	jne    80105ff0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010601f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106022:	a1 20 b1 10 80       	mov    0x8010b120,%eax
80106027:	c7 05 c2 a8 11 80 08 	movl   $0xef000008,0x8011a8c2
8010602e:	00 00 ef 
  initlock(&tickslock, "time");
80106031:	68 7c 80 10 80       	push   $0x8010807c
80106036:	68 80 a6 11 80       	push   $0x8011a680
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010603b:	66 a3 c0 a8 11 80    	mov    %ax,0x8011a8c0
80106041:	c1 e8 10             	shr    $0x10,%eax
80106044:	66 a3 c6 a8 11 80    	mov    %ax,0x8011a8c6
  initlock(&tickslock, "time");
8010604a:	e8 11 ea ff ff       	call   80104a60 <initlock>
}
8010604f:	83 c4 10             	add    $0x10,%esp
80106052:	c9                   	leave  
80106053:	c3                   	ret    
80106054:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop

80106060 <idtinit>:

void
idtinit(void)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
  pd[0] = size-1;
80106065:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010606a:	89 e5                	mov    %esp,%ebp
8010606c:	83 ec 10             	sub    $0x10,%esp
8010606f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106073:	b8 c0 a6 11 80       	mov    $0x8011a6c0,%eax
80106078:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010607c:	c1 e8 10             	shr    $0x10,%eax
8010607f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106083:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106086:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106089:	c9                   	leave  
8010608a:	c3                   	ret    
8010608b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010608f:	90                   	nop

80106090 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	57                   	push   %edi
80106098:	56                   	push   %esi
80106099:	53                   	push   %ebx
8010609a:	83 ec 1c             	sub    $0x1c,%esp
8010609d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801060a0:	8b 43 30             	mov    0x30(%ebx),%eax
801060a3:	83 f8 40             	cmp    $0x40,%eax
801060a6:	0f 84 bc 01 00 00    	je     80106268 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060ac:	83 e8 20             	sub    $0x20,%eax
801060af:	83 f8 1f             	cmp    $0x1f,%eax
801060b2:	77 08                	ja     801060bc <trap+0x2c>
801060b4:	3e ff 24 85 24 81 10 	notrack jmp *-0x7fef7edc(,%eax,4)
801060bb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801060bc:	e8 1f db ff ff       	call   80103be0 <myproc>
801060c1:	8b 7b 38             	mov    0x38(%ebx),%edi
801060c4:	85 c0                	test   %eax,%eax
801060c6:	0f 84 eb 01 00 00    	je     801062b7 <trap+0x227>
801060cc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060d0:	0f 84 e1 01 00 00    	je     801062b7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060d6:	0f 20 d1             	mov    %cr2,%ecx
801060d9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060dc:	e8 df da ff ff       	call   80103bc0 <cpuid>
801060e1:	8b 73 30             	mov    0x30(%ebx),%esi
801060e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060e7:	8b 43 34             	mov    0x34(%ebx),%eax
801060ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801060ed:	e8 ee da ff ff       	call   80103be0 <myproc>
801060f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060f5:	e8 e6 da ff ff       	call   80103be0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060fa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106100:	51                   	push   %ecx
80106101:	57                   	push   %edi
80106102:	52                   	push   %edx
80106103:	ff 75 e4             	pushl  -0x1c(%ebp)
80106106:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106107:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010610a:	83 ee 80             	sub    $0xffffff80,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010610d:	56                   	push   %esi
8010610e:	ff 70 24             	pushl  0x24(%eax)
80106111:	68 e0 80 10 80       	push   $0x801080e0
80106116:	e8 95 a5 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010611b:	83 c4 20             	add    $0x20,%esp
8010611e:	e8 bd da ff ff       	call   80103be0 <myproc>
80106123:	c7 40 38 01 00 00 00 	movl   $0x1,0x38(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010612a:	e8 b1 da ff ff       	call   80103be0 <myproc>
8010612f:	85 c0                	test   %eax,%eax
80106131:	74 1d                	je     80106150 <trap+0xc0>
80106133:	e8 a8 da ff ff       	call   80103be0 <myproc>
80106138:	8b 50 38             	mov    0x38(%eax),%edx
8010613b:	85 d2                	test   %edx,%edx
8010613d:	74 11                	je     80106150 <trap+0xc0>
8010613f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106143:	83 e0 03             	and    $0x3,%eax
80106146:	66 83 f8 03          	cmp    $0x3,%ax
8010614a:	0f 84 50 01 00 00    	je     801062a0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106150:	e8 8b da ff ff       	call   80103be0 <myproc>
80106155:	85 c0                	test   %eax,%eax
80106157:	74 0f                	je     80106168 <trap+0xd8>
80106159:	e8 82 da ff ff       	call   80103be0 <myproc>
8010615e:	83 78 20 04          	cmpl   $0x4,0x20(%eax)
80106162:	0f 84 e8 00 00 00    	je     80106250 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106168:	e8 73 da ff ff       	call   80103be0 <myproc>
8010616d:	85 c0                	test   %eax,%eax
8010616f:	74 1d                	je     8010618e <trap+0xfe>
80106171:	e8 6a da ff ff       	call   80103be0 <myproc>
80106176:	8b 40 38             	mov    0x38(%eax),%eax
80106179:	85 c0                	test   %eax,%eax
8010617b:	74 11                	je     8010618e <trap+0xfe>
8010617d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106181:	83 e0 03             	and    $0x3,%eax
80106184:	66 83 f8 03          	cmp    $0x3,%ax
80106188:	0f 84 03 01 00 00    	je     80106291 <trap+0x201>
    exit();
}
8010618e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106191:	5b                   	pop    %ebx
80106192:	5e                   	pop    %esi
80106193:	5f                   	pop    %edi
80106194:	5d                   	pop    %ebp
80106195:	c3                   	ret    
    ideintr();
80106196:	e8 55 c0 ff ff       	call   801021f0 <ideintr>
    lapiceoi();
8010619b:	e8 30 c7 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061a0:	e8 3b da ff ff       	call   80103be0 <myproc>
801061a5:	85 c0                	test   %eax,%eax
801061a7:	75 8a                	jne    80106133 <trap+0xa3>
801061a9:	eb a5                	jmp    80106150 <trap+0xc0>
    if(cpuid() == 0){
801061ab:	e8 10 da ff ff       	call   80103bc0 <cpuid>
801061b0:	85 c0                	test   %eax,%eax
801061b2:	75 e7                	jne    8010619b <trap+0x10b>
      acquire(&tickslock);
801061b4:	83 ec 0c             	sub    $0xc,%esp
801061b7:	68 80 a6 11 80       	push   $0x8011a680
801061bc:	e8 1f ea ff ff       	call   80104be0 <acquire>
      wakeup(&ticks);
801061c1:	c7 04 24 c0 ae 11 80 	movl   $0x8011aec0,(%esp)
      ticks++;
801061c8:	83 05 c0 ae 11 80 01 	addl   $0x1,0x8011aec0
      wakeup(&ticks);
801061cf:	e8 9c e3 ff ff       	call   80104570 <wakeup>
      release(&tickslock);
801061d4:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
801061db:	e8 c0 ea ff ff       	call   80104ca0 <release>
801061e0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061e3:	eb b6                	jmp    8010619b <trap+0x10b>
    kbdintr();
801061e5:	e8 a6 c5 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
801061ea:	e8 e1 c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ef:	e8 ec d9 ff ff       	call   80103be0 <myproc>
801061f4:	85 c0                	test   %eax,%eax
801061f6:	0f 85 37 ff ff ff    	jne    80106133 <trap+0xa3>
801061fc:	e9 4f ff ff ff       	jmp    80106150 <trap+0xc0>
    uartintr();
80106201:	e8 4a 02 00 00       	call   80106450 <uartintr>
    lapiceoi();
80106206:	e8 c5 c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010620b:	e8 d0 d9 ff ff       	call   80103be0 <myproc>
80106210:	85 c0                	test   %eax,%eax
80106212:	0f 85 1b ff ff ff    	jne    80106133 <trap+0xa3>
80106218:	e9 33 ff ff ff       	jmp    80106150 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010621d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106220:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106224:	e8 97 d9 ff ff       	call   80103bc0 <cpuid>
80106229:	57                   	push   %edi
8010622a:	56                   	push   %esi
8010622b:	50                   	push   %eax
8010622c:	68 88 80 10 80       	push   $0x80108088
80106231:	e8 7a a4 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106236:	e8 95 c6 ff ff       	call   801028d0 <lapiceoi>
    break;
8010623b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010623e:	e8 9d d9 ff ff       	call   80103be0 <myproc>
80106243:	85 c0                	test   %eax,%eax
80106245:	0f 85 e8 fe ff ff    	jne    80106133 <trap+0xa3>
8010624b:	e9 00 ff ff ff       	jmp    80106150 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106250:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106254:	0f 85 0e ff ff ff    	jne    80106168 <trap+0xd8>
    yield();
8010625a:	e8 f1 e0 ff ff       	call   80104350 <yield>
8010625f:	e9 04 ff ff ff       	jmp    80106168 <trap+0xd8>
80106264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106268:	e8 73 d9 ff ff       	call   80103be0 <myproc>
8010626d:	8b 70 38             	mov    0x38(%eax),%esi
80106270:	85 f6                	test   %esi,%esi
80106272:	75 3c                	jne    801062b0 <trap+0x220>
    myproc()->tf = tf;
80106274:	e8 67 d9 ff ff       	call   80103be0 <myproc>
80106279:	89 58 2c             	mov    %ebx,0x2c(%eax)
    syscall();
8010627c:	e8 3f ee ff ff       	call   801050c0 <syscall>
    if(myproc()->killed)
80106281:	e8 5a d9 ff ff       	call   80103be0 <myproc>
80106286:	8b 48 38             	mov    0x38(%eax),%ecx
80106289:	85 c9                	test   %ecx,%ecx
8010628b:	0f 84 fd fe ff ff    	je     8010618e <trap+0xfe>
}
80106291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106294:	5b                   	pop    %ebx
80106295:	5e                   	pop    %esi
80106296:	5f                   	pop    %edi
80106297:	5d                   	pop    %ebp
      exit();
80106298:	e9 73 df ff ff       	jmp    80104210 <exit>
8010629d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801062a0:	e8 6b df ff ff       	call   80104210 <exit>
801062a5:	e9 a6 fe ff ff       	jmp    80106150 <trap+0xc0>
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801062b0:	e8 5b df ff ff       	call   80104210 <exit>
801062b5:	eb bd                	jmp    80106274 <trap+0x1e4>
801062b7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062ba:	e8 01 d9 ff ff       	call   80103bc0 <cpuid>
801062bf:	83 ec 0c             	sub    $0xc,%esp
801062c2:	56                   	push   %esi
801062c3:	57                   	push   %edi
801062c4:	50                   	push   %eax
801062c5:	ff 73 30             	pushl  0x30(%ebx)
801062c8:	68 ac 80 10 80       	push   $0x801080ac
801062cd:	e8 de a3 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801062d2:	83 c4 14             	add    $0x14,%esp
801062d5:	68 81 80 10 80       	push   $0x80108081
801062da:	e8 b1 a0 ff ff       	call   80100390 <panic>
801062df:	90                   	nop

801062e0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801062e0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801062e4:	a1 a0 fa 10 80       	mov    0x8010faa0,%eax
801062e9:	85 c0                	test   %eax,%eax
801062eb:	74 1b                	je     80106308 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ed:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062f2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062f3:	a8 01                	test   $0x1,%al
801062f5:	74 11                	je     80106308 <uartgetc+0x28>
801062f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062fd:	0f b6 c0             	movzbl %al,%eax
80106300:	c3                   	ret    
80106301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010630d:	c3                   	ret    
8010630e:	66 90                	xchg   %ax,%ax

80106310 <uartputc.part.0>:
uartputc(int c)
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	57                   	push   %edi
80106314:	89 c7                	mov    %eax,%edi
80106316:	56                   	push   %esi
80106317:	be fd 03 00 00       	mov    $0x3fd,%esi
8010631c:	53                   	push   %ebx
8010631d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106322:	83 ec 0c             	sub    $0xc,%esp
80106325:	eb 1b                	jmp    80106342 <uartputc.part.0+0x32>
80106327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	6a 0a                	push   $0xa
80106335:	e8 b6 c5 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	83 eb 01             	sub    $0x1,%ebx
80106340:	74 07                	je     80106349 <uartputc.part.0+0x39>
80106342:	89 f2                	mov    %esi,%edx
80106344:	ec                   	in     (%dx),%al
80106345:	a8 20                	test   $0x20,%al
80106347:	74 e7                	je     80106330 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106349:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634e:	89 f8                	mov    %edi,%eax
80106350:	ee                   	out    %al,(%dx)
}
80106351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106354:	5b                   	pop    %ebx
80106355:	5e                   	pop    %esi
80106356:	5f                   	pop    %edi
80106357:	5d                   	pop    %ebp
80106358:	c3                   	ret    
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106360 <uartinit>:
{
80106360:	f3 0f 1e fb          	endbr32 
80106364:	55                   	push   %ebp
80106365:	31 c9                	xor    %ecx,%ecx
80106367:	89 c8                	mov    %ecx,%eax
80106369:	89 e5                	mov    %esp,%ebp
8010636b:	57                   	push   %edi
8010636c:	56                   	push   %esi
8010636d:	53                   	push   %ebx
8010636e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106373:	89 da                	mov    %ebx,%edx
80106375:	83 ec 0c             	sub    $0xc,%esp
80106378:	ee                   	out    %al,(%dx)
80106379:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010637e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106383:	89 fa                	mov    %edi,%edx
80106385:	ee                   	out    %al,(%dx)
80106386:	b8 0c 00 00 00       	mov    $0xc,%eax
8010638b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106390:	ee                   	out    %al,(%dx)
80106391:	be f9 03 00 00       	mov    $0x3f9,%esi
80106396:	89 c8                	mov    %ecx,%eax
80106398:	89 f2                	mov    %esi,%edx
8010639a:	ee                   	out    %al,(%dx)
8010639b:	b8 03 00 00 00       	mov    $0x3,%eax
801063a0:	89 fa                	mov    %edi,%edx
801063a2:	ee                   	out    %al,(%dx)
801063a3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063a8:	89 c8                	mov    %ecx,%eax
801063aa:	ee                   	out    %al,(%dx)
801063ab:	b8 01 00 00 00       	mov    $0x1,%eax
801063b0:	89 f2                	mov    %esi,%edx
801063b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063b3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063b8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063b9:	3c ff                	cmp    $0xff,%al
801063bb:	74 52                	je     8010640f <uartinit+0xaf>
  uart = 1;
801063bd:	c7 05 a0 fa 10 80 01 	movl   $0x1,0x8010faa0
801063c4:	00 00 00 
801063c7:	89 da                	mov    %ebx,%edx
801063c9:	ec                   	in     (%dx),%al
801063ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063cf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063d0:	83 ec 08             	sub    $0x8,%esp
801063d3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801063d8:	bb a4 81 10 80       	mov    $0x801081a4,%ebx
  ioapicenable(IRQ_COM1, 0);
801063dd:	6a 00                	push   $0x0
801063df:	6a 04                	push   $0x4
801063e1:	e8 5a c0 ff ff       	call   80102440 <ioapicenable>
801063e6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063e9:	b8 78 00 00 00       	mov    $0x78,%eax
801063ee:	eb 04                	jmp    801063f4 <uartinit+0x94>
801063f0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801063f4:	8b 15 a0 fa 10 80    	mov    0x8010faa0,%edx
801063fa:	85 d2                	test   %edx,%edx
801063fc:	74 08                	je     80106406 <uartinit+0xa6>
    uartputc(*p);
801063fe:	0f be c0             	movsbl %al,%eax
80106401:	e8 0a ff ff ff       	call   80106310 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106406:	89 f0                	mov    %esi,%eax
80106408:	83 c3 01             	add    $0x1,%ebx
8010640b:	84 c0                	test   %al,%al
8010640d:	75 e1                	jne    801063f0 <uartinit+0x90>
}
8010640f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106412:	5b                   	pop    %ebx
80106413:	5e                   	pop    %esi
80106414:	5f                   	pop    %edi
80106415:	5d                   	pop    %ebp
80106416:	c3                   	ret    
80106417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010641e:	66 90                	xchg   %ax,%ax

80106420 <uartputc>:
{
80106420:	f3 0f 1e fb          	endbr32 
80106424:	55                   	push   %ebp
  if(!uart)
80106425:	8b 15 a0 fa 10 80    	mov    0x8010faa0,%edx
{
8010642b:	89 e5                	mov    %esp,%ebp
8010642d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106430:	85 d2                	test   %edx,%edx
80106432:	74 0c                	je     80106440 <uartputc+0x20>
}
80106434:	5d                   	pop    %ebp
80106435:	e9 d6 fe ff ff       	jmp    80106310 <uartputc.part.0>
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106440:	5d                   	pop    %ebp
80106441:	c3                   	ret    
80106442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106450 <uartintr>:

void
uartintr(void)
{
80106450:	f3 0f 1e fb          	endbr32 
80106454:	55                   	push   %ebp
80106455:	89 e5                	mov    %esp,%ebp
80106457:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010645a:	68 e0 62 10 80       	push   $0x801062e0
8010645f:	e8 fc a3 ff ff       	call   80100860 <consoleintr>
}
80106464:	83 c4 10             	add    $0x10,%esp
80106467:	c9                   	leave  
80106468:	c3                   	ret    

80106469 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $0
8010646b:	6a 00                	push   $0x0
  jmp alltraps
8010646d:	e9 45 fb ff ff       	jmp    80105fb7 <alltraps>

80106472 <vector1>:
.globl vector1
vector1:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $1
80106474:	6a 01                	push   $0x1
  jmp alltraps
80106476:	e9 3c fb ff ff       	jmp    80105fb7 <alltraps>

8010647b <vector2>:
.globl vector2
vector2:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $2
8010647d:	6a 02                	push   $0x2
  jmp alltraps
8010647f:	e9 33 fb ff ff       	jmp    80105fb7 <alltraps>

80106484 <vector3>:
.globl vector3
vector3:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $3
80106486:	6a 03                	push   $0x3
  jmp alltraps
80106488:	e9 2a fb ff ff       	jmp    80105fb7 <alltraps>

8010648d <vector4>:
.globl vector4
vector4:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $4
8010648f:	6a 04                	push   $0x4
  jmp alltraps
80106491:	e9 21 fb ff ff       	jmp    80105fb7 <alltraps>

80106496 <vector5>:
.globl vector5
vector5:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $5
80106498:	6a 05                	push   $0x5
  jmp alltraps
8010649a:	e9 18 fb ff ff       	jmp    80105fb7 <alltraps>

8010649f <vector6>:
.globl vector6
vector6:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $6
801064a1:	6a 06                	push   $0x6
  jmp alltraps
801064a3:	e9 0f fb ff ff       	jmp    80105fb7 <alltraps>

801064a8 <vector7>:
.globl vector7
vector7:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $7
801064aa:	6a 07                	push   $0x7
  jmp alltraps
801064ac:	e9 06 fb ff ff       	jmp    80105fb7 <alltraps>

801064b1 <vector8>:
.globl vector8
vector8:
  pushl $8
801064b1:	6a 08                	push   $0x8
  jmp alltraps
801064b3:	e9 ff fa ff ff       	jmp    80105fb7 <alltraps>

801064b8 <vector9>:
.globl vector9
vector9:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $9
801064ba:	6a 09                	push   $0x9
  jmp alltraps
801064bc:	e9 f6 fa ff ff       	jmp    80105fb7 <alltraps>

801064c1 <vector10>:
.globl vector10
vector10:
  pushl $10
801064c1:	6a 0a                	push   $0xa
  jmp alltraps
801064c3:	e9 ef fa ff ff       	jmp    80105fb7 <alltraps>

801064c8 <vector11>:
.globl vector11
vector11:
  pushl $11
801064c8:	6a 0b                	push   $0xb
  jmp alltraps
801064ca:	e9 e8 fa ff ff       	jmp    80105fb7 <alltraps>

801064cf <vector12>:
.globl vector12
vector12:
  pushl $12
801064cf:	6a 0c                	push   $0xc
  jmp alltraps
801064d1:	e9 e1 fa ff ff       	jmp    80105fb7 <alltraps>

801064d6 <vector13>:
.globl vector13
vector13:
  pushl $13
801064d6:	6a 0d                	push   $0xd
  jmp alltraps
801064d8:	e9 da fa ff ff       	jmp    80105fb7 <alltraps>

801064dd <vector14>:
.globl vector14
vector14:
  pushl $14
801064dd:	6a 0e                	push   $0xe
  jmp alltraps
801064df:	e9 d3 fa ff ff       	jmp    80105fb7 <alltraps>

801064e4 <vector15>:
.globl vector15
vector15:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $15
801064e6:	6a 0f                	push   $0xf
  jmp alltraps
801064e8:	e9 ca fa ff ff       	jmp    80105fb7 <alltraps>

801064ed <vector16>:
.globl vector16
vector16:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $16
801064ef:	6a 10                	push   $0x10
  jmp alltraps
801064f1:	e9 c1 fa ff ff       	jmp    80105fb7 <alltraps>

801064f6 <vector17>:
.globl vector17
vector17:
  pushl $17
801064f6:	6a 11                	push   $0x11
  jmp alltraps
801064f8:	e9 ba fa ff ff       	jmp    80105fb7 <alltraps>

801064fd <vector18>:
.globl vector18
vector18:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $18
801064ff:	6a 12                	push   $0x12
  jmp alltraps
80106501:	e9 b1 fa ff ff       	jmp    80105fb7 <alltraps>

80106506 <vector19>:
.globl vector19
vector19:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $19
80106508:	6a 13                	push   $0x13
  jmp alltraps
8010650a:	e9 a8 fa ff ff       	jmp    80105fb7 <alltraps>

8010650f <vector20>:
.globl vector20
vector20:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $20
80106511:	6a 14                	push   $0x14
  jmp alltraps
80106513:	e9 9f fa ff ff       	jmp    80105fb7 <alltraps>

80106518 <vector21>:
.globl vector21
vector21:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $21
8010651a:	6a 15                	push   $0x15
  jmp alltraps
8010651c:	e9 96 fa ff ff       	jmp    80105fb7 <alltraps>

80106521 <vector22>:
.globl vector22
vector22:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $22
80106523:	6a 16                	push   $0x16
  jmp alltraps
80106525:	e9 8d fa ff ff       	jmp    80105fb7 <alltraps>

8010652a <vector23>:
.globl vector23
vector23:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $23
8010652c:	6a 17                	push   $0x17
  jmp alltraps
8010652e:	e9 84 fa ff ff       	jmp    80105fb7 <alltraps>

80106533 <vector24>:
.globl vector24
vector24:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $24
80106535:	6a 18                	push   $0x18
  jmp alltraps
80106537:	e9 7b fa ff ff       	jmp    80105fb7 <alltraps>

8010653c <vector25>:
.globl vector25
vector25:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $25
8010653e:	6a 19                	push   $0x19
  jmp alltraps
80106540:	e9 72 fa ff ff       	jmp    80105fb7 <alltraps>

80106545 <vector26>:
.globl vector26
vector26:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $26
80106547:	6a 1a                	push   $0x1a
  jmp alltraps
80106549:	e9 69 fa ff ff       	jmp    80105fb7 <alltraps>

8010654e <vector27>:
.globl vector27
vector27:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $27
80106550:	6a 1b                	push   $0x1b
  jmp alltraps
80106552:	e9 60 fa ff ff       	jmp    80105fb7 <alltraps>

80106557 <vector28>:
.globl vector28
vector28:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $28
80106559:	6a 1c                	push   $0x1c
  jmp alltraps
8010655b:	e9 57 fa ff ff       	jmp    80105fb7 <alltraps>

80106560 <vector29>:
.globl vector29
vector29:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $29
80106562:	6a 1d                	push   $0x1d
  jmp alltraps
80106564:	e9 4e fa ff ff       	jmp    80105fb7 <alltraps>

80106569 <vector30>:
.globl vector30
vector30:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $30
8010656b:	6a 1e                	push   $0x1e
  jmp alltraps
8010656d:	e9 45 fa ff ff       	jmp    80105fb7 <alltraps>

80106572 <vector31>:
.globl vector31
vector31:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $31
80106574:	6a 1f                	push   $0x1f
  jmp alltraps
80106576:	e9 3c fa ff ff       	jmp    80105fb7 <alltraps>

8010657b <vector32>:
.globl vector32
vector32:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $32
8010657d:	6a 20                	push   $0x20
  jmp alltraps
8010657f:	e9 33 fa ff ff       	jmp    80105fb7 <alltraps>

80106584 <vector33>:
.globl vector33
vector33:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $33
80106586:	6a 21                	push   $0x21
  jmp alltraps
80106588:	e9 2a fa ff ff       	jmp    80105fb7 <alltraps>

8010658d <vector34>:
.globl vector34
vector34:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $34
8010658f:	6a 22                	push   $0x22
  jmp alltraps
80106591:	e9 21 fa ff ff       	jmp    80105fb7 <alltraps>

80106596 <vector35>:
.globl vector35
vector35:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $35
80106598:	6a 23                	push   $0x23
  jmp alltraps
8010659a:	e9 18 fa ff ff       	jmp    80105fb7 <alltraps>

8010659f <vector36>:
.globl vector36
vector36:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $36
801065a1:	6a 24                	push   $0x24
  jmp alltraps
801065a3:	e9 0f fa ff ff       	jmp    80105fb7 <alltraps>

801065a8 <vector37>:
.globl vector37
vector37:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $37
801065aa:	6a 25                	push   $0x25
  jmp alltraps
801065ac:	e9 06 fa ff ff       	jmp    80105fb7 <alltraps>

801065b1 <vector38>:
.globl vector38
vector38:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $38
801065b3:	6a 26                	push   $0x26
  jmp alltraps
801065b5:	e9 fd f9 ff ff       	jmp    80105fb7 <alltraps>

801065ba <vector39>:
.globl vector39
vector39:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $39
801065bc:	6a 27                	push   $0x27
  jmp alltraps
801065be:	e9 f4 f9 ff ff       	jmp    80105fb7 <alltraps>

801065c3 <vector40>:
.globl vector40
vector40:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $40
801065c5:	6a 28                	push   $0x28
  jmp alltraps
801065c7:	e9 eb f9 ff ff       	jmp    80105fb7 <alltraps>

801065cc <vector41>:
.globl vector41
vector41:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $41
801065ce:	6a 29                	push   $0x29
  jmp alltraps
801065d0:	e9 e2 f9 ff ff       	jmp    80105fb7 <alltraps>

801065d5 <vector42>:
.globl vector42
vector42:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $42
801065d7:	6a 2a                	push   $0x2a
  jmp alltraps
801065d9:	e9 d9 f9 ff ff       	jmp    80105fb7 <alltraps>

801065de <vector43>:
.globl vector43
vector43:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $43
801065e0:	6a 2b                	push   $0x2b
  jmp alltraps
801065e2:	e9 d0 f9 ff ff       	jmp    80105fb7 <alltraps>

801065e7 <vector44>:
.globl vector44
vector44:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $44
801065e9:	6a 2c                	push   $0x2c
  jmp alltraps
801065eb:	e9 c7 f9 ff ff       	jmp    80105fb7 <alltraps>

801065f0 <vector45>:
.globl vector45
vector45:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $45
801065f2:	6a 2d                	push   $0x2d
  jmp alltraps
801065f4:	e9 be f9 ff ff       	jmp    80105fb7 <alltraps>

801065f9 <vector46>:
.globl vector46
vector46:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $46
801065fb:	6a 2e                	push   $0x2e
  jmp alltraps
801065fd:	e9 b5 f9 ff ff       	jmp    80105fb7 <alltraps>

80106602 <vector47>:
.globl vector47
vector47:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $47
80106604:	6a 2f                	push   $0x2f
  jmp alltraps
80106606:	e9 ac f9 ff ff       	jmp    80105fb7 <alltraps>

8010660b <vector48>:
.globl vector48
vector48:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $48
8010660d:	6a 30                	push   $0x30
  jmp alltraps
8010660f:	e9 a3 f9 ff ff       	jmp    80105fb7 <alltraps>

80106614 <vector49>:
.globl vector49
vector49:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $49
80106616:	6a 31                	push   $0x31
  jmp alltraps
80106618:	e9 9a f9 ff ff       	jmp    80105fb7 <alltraps>

8010661d <vector50>:
.globl vector50
vector50:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $50
8010661f:	6a 32                	push   $0x32
  jmp alltraps
80106621:	e9 91 f9 ff ff       	jmp    80105fb7 <alltraps>

80106626 <vector51>:
.globl vector51
vector51:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $51
80106628:	6a 33                	push   $0x33
  jmp alltraps
8010662a:	e9 88 f9 ff ff       	jmp    80105fb7 <alltraps>

8010662f <vector52>:
.globl vector52
vector52:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $52
80106631:	6a 34                	push   $0x34
  jmp alltraps
80106633:	e9 7f f9 ff ff       	jmp    80105fb7 <alltraps>

80106638 <vector53>:
.globl vector53
vector53:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $53
8010663a:	6a 35                	push   $0x35
  jmp alltraps
8010663c:	e9 76 f9 ff ff       	jmp    80105fb7 <alltraps>

80106641 <vector54>:
.globl vector54
vector54:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $54
80106643:	6a 36                	push   $0x36
  jmp alltraps
80106645:	e9 6d f9 ff ff       	jmp    80105fb7 <alltraps>

8010664a <vector55>:
.globl vector55
vector55:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $55
8010664c:	6a 37                	push   $0x37
  jmp alltraps
8010664e:	e9 64 f9 ff ff       	jmp    80105fb7 <alltraps>

80106653 <vector56>:
.globl vector56
vector56:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $56
80106655:	6a 38                	push   $0x38
  jmp alltraps
80106657:	e9 5b f9 ff ff       	jmp    80105fb7 <alltraps>

8010665c <vector57>:
.globl vector57
vector57:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $57
8010665e:	6a 39                	push   $0x39
  jmp alltraps
80106660:	e9 52 f9 ff ff       	jmp    80105fb7 <alltraps>

80106665 <vector58>:
.globl vector58
vector58:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $58
80106667:	6a 3a                	push   $0x3a
  jmp alltraps
80106669:	e9 49 f9 ff ff       	jmp    80105fb7 <alltraps>

8010666e <vector59>:
.globl vector59
vector59:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $59
80106670:	6a 3b                	push   $0x3b
  jmp alltraps
80106672:	e9 40 f9 ff ff       	jmp    80105fb7 <alltraps>

80106677 <vector60>:
.globl vector60
vector60:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $60
80106679:	6a 3c                	push   $0x3c
  jmp alltraps
8010667b:	e9 37 f9 ff ff       	jmp    80105fb7 <alltraps>

80106680 <vector61>:
.globl vector61
vector61:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $61
80106682:	6a 3d                	push   $0x3d
  jmp alltraps
80106684:	e9 2e f9 ff ff       	jmp    80105fb7 <alltraps>

80106689 <vector62>:
.globl vector62
vector62:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $62
8010668b:	6a 3e                	push   $0x3e
  jmp alltraps
8010668d:	e9 25 f9 ff ff       	jmp    80105fb7 <alltraps>

80106692 <vector63>:
.globl vector63
vector63:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $63
80106694:	6a 3f                	push   $0x3f
  jmp alltraps
80106696:	e9 1c f9 ff ff       	jmp    80105fb7 <alltraps>

8010669b <vector64>:
.globl vector64
vector64:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $64
8010669d:	6a 40                	push   $0x40
  jmp alltraps
8010669f:	e9 13 f9 ff ff       	jmp    80105fb7 <alltraps>

801066a4 <vector65>:
.globl vector65
vector65:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $65
801066a6:	6a 41                	push   $0x41
  jmp alltraps
801066a8:	e9 0a f9 ff ff       	jmp    80105fb7 <alltraps>

801066ad <vector66>:
.globl vector66
vector66:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $66
801066af:	6a 42                	push   $0x42
  jmp alltraps
801066b1:	e9 01 f9 ff ff       	jmp    80105fb7 <alltraps>

801066b6 <vector67>:
.globl vector67
vector67:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $67
801066b8:	6a 43                	push   $0x43
  jmp alltraps
801066ba:	e9 f8 f8 ff ff       	jmp    80105fb7 <alltraps>

801066bf <vector68>:
.globl vector68
vector68:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $68
801066c1:	6a 44                	push   $0x44
  jmp alltraps
801066c3:	e9 ef f8 ff ff       	jmp    80105fb7 <alltraps>

801066c8 <vector69>:
.globl vector69
vector69:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $69
801066ca:	6a 45                	push   $0x45
  jmp alltraps
801066cc:	e9 e6 f8 ff ff       	jmp    80105fb7 <alltraps>

801066d1 <vector70>:
.globl vector70
vector70:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $70
801066d3:	6a 46                	push   $0x46
  jmp alltraps
801066d5:	e9 dd f8 ff ff       	jmp    80105fb7 <alltraps>

801066da <vector71>:
.globl vector71
vector71:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $71
801066dc:	6a 47                	push   $0x47
  jmp alltraps
801066de:	e9 d4 f8 ff ff       	jmp    80105fb7 <alltraps>

801066e3 <vector72>:
.globl vector72
vector72:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $72
801066e5:	6a 48                	push   $0x48
  jmp alltraps
801066e7:	e9 cb f8 ff ff       	jmp    80105fb7 <alltraps>

801066ec <vector73>:
.globl vector73
vector73:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $73
801066ee:	6a 49                	push   $0x49
  jmp alltraps
801066f0:	e9 c2 f8 ff ff       	jmp    80105fb7 <alltraps>

801066f5 <vector74>:
.globl vector74
vector74:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $74
801066f7:	6a 4a                	push   $0x4a
  jmp alltraps
801066f9:	e9 b9 f8 ff ff       	jmp    80105fb7 <alltraps>

801066fe <vector75>:
.globl vector75
vector75:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $75
80106700:	6a 4b                	push   $0x4b
  jmp alltraps
80106702:	e9 b0 f8 ff ff       	jmp    80105fb7 <alltraps>

80106707 <vector76>:
.globl vector76
vector76:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $76
80106709:	6a 4c                	push   $0x4c
  jmp alltraps
8010670b:	e9 a7 f8 ff ff       	jmp    80105fb7 <alltraps>

80106710 <vector77>:
.globl vector77
vector77:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $77
80106712:	6a 4d                	push   $0x4d
  jmp alltraps
80106714:	e9 9e f8 ff ff       	jmp    80105fb7 <alltraps>

80106719 <vector78>:
.globl vector78
vector78:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $78
8010671b:	6a 4e                	push   $0x4e
  jmp alltraps
8010671d:	e9 95 f8 ff ff       	jmp    80105fb7 <alltraps>

80106722 <vector79>:
.globl vector79
vector79:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $79
80106724:	6a 4f                	push   $0x4f
  jmp alltraps
80106726:	e9 8c f8 ff ff       	jmp    80105fb7 <alltraps>

8010672b <vector80>:
.globl vector80
vector80:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $80
8010672d:	6a 50                	push   $0x50
  jmp alltraps
8010672f:	e9 83 f8 ff ff       	jmp    80105fb7 <alltraps>

80106734 <vector81>:
.globl vector81
vector81:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $81
80106736:	6a 51                	push   $0x51
  jmp alltraps
80106738:	e9 7a f8 ff ff       	jmp    80105fb7 <alltraps>

8010673d <vector82>:
.globl vector82
vector82:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $82
8010673f:	6a 52                	push   $0x52
  jmp alltraps
80106741:	e9 71 f8 ff ff       	jmp    80105fb7 <alltraps>

80106746 <vector83>:
.globl vector83
vector83:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $83
80106748:	6a 53                	push   $0x53
  jmp alltraps
8010674a:	e9 68 f8 ff ff       	jmp    80105fb7 <alltraps>

8010674f <vector84>:
.globl vector84
vector84:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $84
80106751:	6a 54                	push   $0x54
  jmp alltraps
80106753:	e9 5f f8 ff ff       	jmp    80105fb7 <alltraps>

80106758 <vector85>:
.globl vector85
vector85:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $85
8010675a:	6a 55                	push   $0x55
  jmp alltraps
8010675c:	e9 56 f8 ff ff       	jmp    80105fb7 <alltraps>

80106761 <vector86>:
.globl vector86
vector86:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $86
80106763:	6a 56                	push   $0x56
  jmp alltraps
80106765:	e9 4d f8 ff ff       	jmp    80105fb7 <alltraps>

8010676a <vector87>:
.globl vector87
vector87:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $87
8010676c:	6a 57                	push   $0x57
  jmp alltraps
8010676e:	e9 44 f8 ff ff       	jmp    80105fb7 <alltraps>

80106773 <vector88>:
.globl vector88
vector88:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $88
80106775:	6a 58                	push   $0x58
  jmp alltraps
80106777:	e9 3b f8 ff ff       	jmp    80105fb7 <alltraps>

8010677c <vector89>:
.globl vector89
vector89:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $89
8010677e:	6a 59                	push   $0x59
  jmp alltraps
80106780:	e9 32 f8 ff ff       	jmp    80105fb7 <alltraps>

80106785 <vector90>:
.globl vector90
vector90:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $90
80106787:	6a 5a                	push   $0x5a
  jmp alltraps
80106789:	e9 29 f8 ff ff       	jmp    80105fb7 <alltraps>

8010678e <vector91>:
.globl vector91
vector91:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $91
80106790:	6a 5b                	push   $0x5b
  jmp alltraps
80106792:	e9 20 f8 ff ff       	jmp    80105fb7 <alltraps>

80106797 <vector92>:
.globl vector92
vector92:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $92
80106799:	6a 5c                	push   $0x5c
  jmp alltraps
8010679b:	e9 17 f8 ff ff       	jmp    80105fb7 <alltraps>

801067a0 <vector93>:
.globl vector93
vector93:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $93
801067a2:	6a 5d                	push   $0x5d
  jmp alltraps
801067a4:	e9 0e f8 ff ff       	jmp    80105fb7 <alltraps>

801067a9 <vector94>:
.globl vector94
vector94:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $94
801067ab:	6a 5e                	push   $0x5e
  jmp alltraps
801067ad:	e9 05 f8 ff ff       	jmp    80105fb7 <alltraps>

801067b2 <vector95>:
.globl vector95
vector95:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $95
801067b4:	6a 5f                	push   $0x5f
  jmp alltraps
801067b6:	e9 fc f7 ff ff       	jmp    80105fb7 <alltraps>

801067bb <vector96>:
.globl vector96
vector96:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $96
801067bd:	6a 60                	push   $0x60
  jmp alltraps
801067bf:	e9 f3 f7 ff ff       	jmp    80105fb7 <alltraps>

801067c4 <vector97>:
.globl vector97
vector97:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $97
801067c6:	6a 61                	push   $0x61
  jmp alltraps
801067c8:	e9 ea f7 ff ff       	jmp    80105fb7 <alltraps>

801067cd <vector98>:
.globl vector98
vector98:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $98
801067cf:	6a 62                	push   $0x62
  jmp alltraps
801067d1:	e9 e1 f7 ff ff       	jmp    80105fb7 <alltraps>

801067d6 <vector99>:
.globl vector99
vector99:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $99
801067d8:	6a 63                	push   $0x63
  jmp alltraps
801067da:	e9 d8 f7 ff ff       	jmp    80105fb7 <alltraps>

801067df <vector100>:
.globl vector100
vector100:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $100
801067e1:	6a 64                	push   $0x64
  jmp alltraps
801067e3:	e9 cf f7 ff ff       	jmp    80105fb7 <alltraps>

801067e8 <vector101>:
.globl vector101
vector101:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $101
801067ea:	6a 65                	push   $0x65
  jmp alltraps
801067ec:	e9 c6 f7 ff ff       	jmp    80105fb7 <alltraps>

801067f1 <vector102>:
.globl vector102
vector102:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $102
801067f3:	6a 66                	push   $0x66
  jmp alltraps
801067f5:	e9 bd f7 ff ff       	jmp    80105fb7 <alltraps>

801067fa <vector103>:
.globl vector103
vector103:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $103
801067fc:	6a 67                	push   $0x67
  jmp alltraps
801067fe:	e9 b4 f7 ff ff       	jmp    80105fb7 <alltraps>

80106803 <vector104>:
.globl vector104
vector104:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $104
80106805:	6a 68                	push   $0x68
  jmp alltraps
80106807:	e9 ab f7 ff ff       	jmp    80105fb7 <alltraps>

8010680c <vector105>:
.globl vector105
vector105:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $105
8010680e:	6a 69                	push   $0x69
  jmp alltraps
80106810:	e9 a2 f7 ff ff       	jmp    80105fb7 <alltraps>

80106815 <vector106>:
.globl vector106
vector106:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $106
80106817:	6a 6a                	push   $0x6a
  jmp alltraps
80106819:	e9 99 f7 ff ff       	jmp    80105fb7 <alltraps>

8010681e <vector107>:
.globl vector107
vector107:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $107
80106820:	6a 6b                	push   $0x6b
  jmp alltraps
80106822:	e9 90 f7 ff ff       	jmp    80105fb7 <alltraps>

80106827 <vector108>:
.globl vector108
vector108:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $108
80106829:	6a 6c                	push   $0x6c
  jmp alltraps
8010682b:	e9 87 f7 ff ff       	jmp    80105fb7 <alltraps>

80106830 <vector109>:
.globl vector109
vector109:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $109
80106832:	6a 6d                	push   $0x6d
  jmp alltraps
80106834:	e9 7e f7 ff ff       	jmp    80105fb7 <alltraps>

80106839 <vector110>:
.globl vector110
vector110:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $110
8010683b:	6a 6e                	push   $0x6e
  jmp alltraps
8010683d:	e9 75 f7 ff ff       	jmp    80105fb7 <alltraps>

80106842 <vector111>:
.globl vector111
vector111:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $111
80106844:	6a 6f                	push   $0x6f
  jmp alltraps
80106846:	e9 6c f7 ff ff       	jmp    80105fb7 <alltraps>

8010684b <vector112>:
.globl vector112
vector112:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $112
8010684d:	6a 70                	push   $0x70
  jmp alltraps
8010684f:	e9 63 f7 ff ff       	jmp    80105fb7 <alltraps>

80106854 <vector113>:
.globl vector113
vector113:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $113
80106856:	6a 71                	push   $0x71
  jmp alltraps
80106858:	e9 5a f7 ff ff       	jmp    80105fb7 <alltraps>

8010685d <vector114>:
.globl vector114
vector114:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $114
8010685f:	6a 72                	push   $0x72
  jmp alltraps
80106861:	e9 51 f7 ff ff       	jmp    80105fb7 <alltraps>

80106866 <vector115>:
.globl vector115
vector115:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $115
80106868:	6a 73                	push   $0x73
  jmp alltraps
8010686a:	e9 48 f7 ff ff       	jmp    80105fb7 <alltraps>

8010686f <vector116>:
.globl vector116
vector116:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $116
80106871:	6a 74                	push   $0x74
  jmp alltraps
80106873:	e9 3f f7 ff ff       	jmp    80105fb7 <alltraps>

80106878 <vector117>:
.globl vector117
vector117:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $117
8010687a:	6a 75                	push   $0x75
  jmp alltraps
8010687c:	e9 36 f7 ff ff       	jmp    80105fb7 <alltraps>

80106881 <vector118>:
.globl vector118
vector118:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $118
80106883:	6a 76                	push   $0x76
  jmp alltraps
80106885:	e9 2d f7 ff ff       	jmp    80105fb7 <alltraps>

8010688a <vector119>:
.globl vector119
vector119:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $119
8010688c:	6a 77                	push   $0x77
  jmp alltraps
8010688e:	e9 24 f7 ff ff       	jmp    80105fb7 <alltraps>

80106893 <vector120>:
.globl vector120
vector120:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $120
80106895:	6a 78                	push   $0x78
  jmp alltraps
80106897:	e9 1b f7 ff ff       	jmp    80105fb7 <alltraps>

8010689c <vector121>:
.globl vector121
vector121:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $121
8010689e:	6a 79                	push   $0x79
  jmp alltraps
801068a0:	e9 12 f7 ff ff       	jmp    80105fb7 <alltraps>

801068a5 <vector122>:
.globl vector122
vector122:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $122
801068a7:	6a 7a                	push   $0x7a
  jmp alltraps
801068a9:	e9 09 f7 ff ff       	jmp    80105fb7 <alltraps>

801068ae <vector123>:
.globl vector123
vector123:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $123
801068b0:	6a 7b                	push   $0x7b
  jmp alltraps
801068b2:	e9 00 f7 ff ff       	jmp    80105fb7 <alltraps>

801068b7 <vector124>:
.globl vector124
vector124:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $124
801068b9:	6a 7c                	push   $0x7c
  jmp alltraps
801068bb:	e9 f7 f6 ff ff       	jmp    80105fb7 <alltraps>

801068c0 <vector125>:
.globl vector125
vector125:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $125
801068c2:	6a 7d                	push   $0x7d
  jmp alltraps
801068c4:	e9 ee f6 ff ff       	jmp    80105fb7 <alltraps>

801068c9 <vector126>:
.globl vector126
vector126:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $126
801068cb:	6a 7e                	push   $0x7e
  jmp alltraps
801068cd:	e9 e5 f6 ff ff       	jmp    80105fb7 <alltraps>

801068d2 <vector127>:
.globl vector127
vector127:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $127
801068d4:	6a 7f                	push   $0x7f
  jmp alltraps
801068d6:	e9 dc f6 ff ff       	jmp    80105fb7 <alltraps>

801068db <vector128>:
.globl vector128
vector128:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $128
801068dd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068e2:	e9 d0 f6 ff ff       	jmp    80105fb7 <alltraps>

801068e7 <vector129>:
.globl vector129
vector129:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $129
801068e9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068ee:	e9 c4 f6 ff ff       	jmp    80105fb7 <alltraps>

801068f3 <vector130>:
.globl vector130
vector130:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $130
801068f5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068fa:	e9 b8 f6 ff ff       	jmp    80105fb7 <alltraps>

801068ff <vector131>:
.globl vector131
vector131:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $131
80106901:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106906:	e9 ac f6 ff ff       	jmp    80105fb7 <alltraps>

8010690b <vector132>:
.globl vector132
vector132:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $132
8010690d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106912:	e9 a0 f6 ff ff       	jmp    80105fb7 <alltraps>

80106917 <vector133>:
.globl vector133
vector133:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $133
80106919:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010691e:	e9 94 f6 ff ff       	jmp    80105fb7 <alltraps>

80106923 <vector134>:
.globl vector134
vector134:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $134
80106925:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010692a:	e9 88 f6 ff ff       	jmp    80105fb7 <alltraps>

8010692f <vector135>:
.globl vector135
vector135:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $135
80106931:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106936:	e9 7c f6 ff ff       	jmp    80105fb7 <alltraps>

8010693b <vector136>:
.globl vector136
vector136:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $136
8010693d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106942:	e9 70 f6 ff ff       	jmp    80105fb7 <alltraps>

80106947 <vector137>:
.globl vector137
vector137:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $137
80106949:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010694e:	e9 64 f6 ff ff       	jmp    80105fb7 <alltraps>

80106953 <vector138>:
.globl vector138
vector138:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $138
80106955:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010695a:	e9 58 f6 ff ff       	jmp    80105fb7 <alltraps>

8010695f <vector139>:
.globl vector139
vector139:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $139
80106961:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106966:	e9 4c f6 ff ff       	jmp    80105fb7 <alltraps>

8010696b <vector140>:
.globl vector140
vector140:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $140
8010696d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106972:	e9 40 f6 ff ff       	jmp    80105fb7 <alltraps>

80106977 <vector141>:
.globl vector141
vector141:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $141
80106979:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010697e:	e9 34 f6 ff ff       	jmp    80105fb7 <alltraps>

80106983 <vector142>:
.globl vector142
vector142:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $142
80106985:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010698a:	e9 28 f6 ff ff       	jmp    80105fb7 <alltraps>

8010698f <vector143>:
.globl vector143
vector143:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $143
80106991:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106996:	e9 1c f6 ff ff       	jmp    80105fb7 <alltraps>

8010699b <vector144>:
.globl vector144
vector144:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $144
8010699d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069a2:	e9 10 f6 ff ff       	jmp    80105fb7 <alltraps>

801069a7 <vector145>:
.globl vector145
vector145:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $145
801069a9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069ae:	e9 04 f6 ff ff       	jmp    80105fb7 <alltraps>

801069b3 <vector146>:
.globl vector146
vector146:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $146
801069b5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069ba:	e9 f8 f5 ff ff       	jmp    80105fb7 <alltraps>

801069bf <vector147>:
.globl vector147
vector147:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $147
801069c1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069c6:	e9 ec f5 ff ff       	jmp    80105fb7 <alltraps>

801069cb <vector148>:
.globl vector148
vector148:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $148
801069cd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069d2:	e9 e0 f5 ff ff       	jmp    80105fb7 <alltraps>

801069d7 <vector149>:
.globl vector149
vector149:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $149
801069d9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069de:	e9 d4 f5 ff ff       	jmp    80105fb7 <alltraps>

801069e3 <vector150>:
.globl vector150
vector150:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $150
801069e5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069ea:	e9 c8 f5 ff ff       	jmp    80105fb7 <alltraps>

801069ef <vector151>:
.globl vector151
vector151:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $151
801069f1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069f6:	e9 bc f5 ff ff       	jmp    80105fb7 <alltraps>

801069fb <vector152>:
.globl vector152
vector152:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $152
801069fd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a02:	e9 b0 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a07 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $153
80106a09:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a0e:	e9 a4 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a13 <vector154>:
.globl vector154
vector154:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $154
80106a15:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a1a:	e9 98 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a1f <vector155>:
.globl vector155
vector155:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $155
80106a21:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a26:	e9 8c f5 ff ff       	jmp    80105fb7 <alltraps>

80106a2b <vector156>:
.globl vector156
vector156:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $156
80106a2d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a32:	e9 80 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a37 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $157
80106a39:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a3e:	e9 74 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a43 <vector158>:
.globl vector158
vector158:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $158
80106a45:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a4a:	e9 68 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a4f <vector159>:
.globl vector159
vector159:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $159
80106a51:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a56:	e9 5c f5 ff ff       	jmp    80105fb7 <alltraps>

80106a5b <vector160>:
.globl vector160
vector160:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $160
80106a5d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a62:	e9 50 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a67 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $161
80106a69:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a6e:	e9 44 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a73 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $162
80106a75:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a7a:	e9 38 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a7f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $163
80106a81:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a86:	e9 2c f5 ff ff       	jmp    80105fb7 <alltraps>

80106a8b <vector164>:
.globl vector164
vector164:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $164
80106a8d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a92:	e9 20 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a97 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $165
80106a99:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a9e:	e9 14 f5 ff ff       	jmp    80105fb7 <alltraps>

80106aa3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $166
80106aa5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106aaa:	e9 08 f5 ff ff       	jmp    80105fb7 <alltraps>

80106aaf <vector167>:
.globl vector167
vector167:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $167
80106ab1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ab6:	e9 fc f4 ff ff       	jmp    80105fb7 <alltraps>

80106abb <vector168>:
.globl vector168
vector168:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $168
80106abd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ac2:	e9 f0 f4 ff ff       	jmp    80105fb7 <alltraps>

80106ac7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $169
80106ac9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106ace:	e9 e4 f4 ff ff       	jmp    80105fb7 <alltraps>

80106ad3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $170
80106ad5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ada:	e9 d8 f4 ff ff       	jmp    80105fb7 <alltraps>

80106adf <vector171>:
.globl vector171
vector171:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $171
80106ae1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ae6:	e9 cc f4 ff ff       	jmp    80105fb7 <alltraps>

80106aeb <vector172>:
.globl vector172
vector172:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $172
80106aed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106af2:	e9 c0 f4 ff ff       	jmp    80105fb7 <alltraps>

80106af7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $173
80106af9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106afe:	e9 b4 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b03 <vector174>:
.globl vector174
vector174:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $174
80106b05:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b0a:	e9 a8 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b0f <vector175>:
.globl vector175
vector175:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $175
80106b11:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b16:	e9 9c f4 ff ff       	jmp    80105fb7 <alltraps>

80106b1b <vector176>:
.globl vector176
vector176:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $176
80106b1d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b22:	e9 90 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b27 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $177
80106b29:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b2e:	e9 84 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b33 <vector178>:
.globl vector178
vector178:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $178
80106b35:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b3a:	e9 78 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b3f <vector179>:
.globl vector179
vector179:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $179
80106b41:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b46:	e9 6c f4 ff ff       	jmp    80105fb7 <alltraps>

80106b4b <vector180>:
.globl vector180
vector180:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $180
80106b4d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b52:	e9 60 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b57 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $181
80106b59:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b5e:	e9 54 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b63 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $182
80106b65:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b6a:	e9 48 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b6f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $183
80106b71:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b76:	e9 3c f4 ff ff       	jmp    80105fb7 <alltraps>

80106b7b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $184
80106b7d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b82:	e9 30 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b87 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $185
80106b89:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b8e:	e9 24 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b93 <vector186>:
.globl vector186
vector186:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $186
80106b95:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b9a:	e9 18 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b9f <vector187>:
.globl vector187
vector187:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $187
80106ba1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ba6:	e9 0c f4 ff ff       	jmp    80105fb7 <alltraps>

80106bab <vector188>:
.globl vector188
vector188:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $188
80106bad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bb2:	e9 00 f4 ff ff       	jmp    80105fb7 <alltraps>

80106bb7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $189
80106bb9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bbe:	e9 f4 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bc3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $190
80106bc5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bca:	e9 e8 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bcf <vector191>:
.globl vector191
vector191:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $191
80106bd1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106bd6:	e9 dc f3 ff ff       	jmp    80105fb7 <alltraps>

80106bdb <vector192>:
.globl vector192
vector192:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $192
80106bdd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106be2:	e9 d0 f3 ff ff       	jmp    80105fb7 <alltraps>

80106be7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $193
80106be9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bee:	e9 c4 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bf3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $194
80106bf5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bfa:	e9 b8 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bff <vector195>:
.globl vector195
vector195:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $195
80106c01:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c06:	e9 ac f3 ff ff       	jmp    80105fb7 <alltraps>

80106c0b <vector196>:
.globl vector196
vector196:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $196
80106c0d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c12:	e9 a0 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c17 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $197
80106c19:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c1e:	e9 94 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c23 <vector198>:
.globl vector198
vector198:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $198
80106c25:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c2a:	e9 88 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c2f <vector199>:
.globl vector199
vector199:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $199
80106c31:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c36:	e9 7c f3 ff ff       	jmp    80105fb7 <alltraps>

80106c3b <vector200>:
.globl vector200
vector200:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $200
80106c3d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c42:	e9 70 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c47 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $201
80106c49:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c4e:	e9 64 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c53 <vector202>:
.globl vector202
vector202:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $202
80106c55:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c5a:	e9 58 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c5f <vector203>:
.globl vector203
vector203:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $203
80106c61:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c66:	e9 4c f3 ff ff       	jmp    80105fb7 <alltraps>

80106c6b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $204
80106c6d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c72:	e9 40 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c77 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $205
80106c79:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c7e:	e9 34 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c83 <vector206>:
.globl vector206
vector206:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $206
80106c85:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c8a:	e9 28 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c8f <vector207>:
.globl vector207
vector207:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $207
80106c91:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c96:	e9 1c f3 ff ff       	jmp    80105fb7 <alltraps>

80106c9b <vector208>:
.globl vector208
vector208:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $208
80106c9d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ca2:	e9 10 f3 ff ff       	jmp    80105fb7 <alltraps>

80106ca7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $209
80106ca9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cae:	e9 04 f3 ff ff       	jmp    80105fb7 <alltraps>

80106cb3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $210
80106cb5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106cba:	e9 f8 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cbf <vector211>:
.globl vector211
vector211:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $211
80106cc1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106cc6:	e9 ec f2 ff ff       	jmp    80105fb7 <alltraps>

80106ccb <vector212>:
.globl vector212
vector212:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $212
80106ccd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cd2:	e9 e0 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cd7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $213
80106cd9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106cde:	e9 d4 f2 ff ff       	jmp    80105fb7 <alltraps>

80106ce3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $214
80106ce5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106cea:	e9 c8 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cef <vector215>:
.globl vector215
vector215:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $215
80106cf1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cf6:	e9 bc f2 ff ff       	jmp    80105fb7 <alltraps>

80106cfb <vector216>:
.globl vector216
vector216:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $216
80106cfd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d02:	e9 b0 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d07 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $217
80106d09:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d0e:	e9 a4 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d13 <vector218>:
.globl vector218
vector218:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $218
80106d15:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d1a:	e9 98 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d1f <vector219>:
.globl vector219
vector219:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $219
80106d21:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d26:	e9 8c f2 ff ff       	jmp    80105fb7 <alltraps>

80106d2b <vector220>:
.globl vector220
vector220:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $220
80106d2d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d32:	e9 80 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d37 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $221
80106d39:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d3e:	e9 74 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d43 <vector222>:
.globl vector222
vector222:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $222
80106d45:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d4a:	e9 68 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d4f <vector223>:
.globl vector223
vector223:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $223
80106d51:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d56:	e9 5c f2 ff ff       	jmp    80105fb7 <alltraps>

80106d5b <vector224>:
.globl vector224
vector224:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $224
80106d5d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d62:	e9 50 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d67 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $225
80106d69:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d6e:	e9 44 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d73 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $226
80106d75:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d7a:	e9 38 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d7f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $227
80106d81:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d86:	e9 2c f2 ff ff       	jmp    80105fb7 <alltraps>

80106d8b <vector228>:
.globl vector228
vector228:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $228
80106d8d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d92:	e9 20 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d97 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $229
80106d99:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d9e:	e9 14 f2 ff ff       	jmp    80105fb7 <alltraps>

80106da3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $230
80106da5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106daa:	e9 08 f2 ff ff       	jmp    80105fb7 <alltraps>

80106daf <vector231>:
.globl vector231
vector231:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $231
80106db1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106db6:	e9 fc f1 ff ff       	jmp    80105fb7 <alltraps>

80106dbb <vector232>:
.globl vector232
vector232:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $232
80106dbd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dc2:	e9 f0 f1 ff ff       	jmp    80105fb7 <alltraps>

80106dc7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $233
80106dc9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dce:	e9 e4 f1 ff ff       	jmp    80105fb7 <alltraps>

80106dd3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $234
80106dd5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106dda:	e9 d8 f1 ff ff       	jmp    80105fb7 <alltraps>

80106ddf <vector235>:
.globl vector235
vector235:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $235
80106de1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106de6:	e9 cc f1 ff ff       	jmp    80105fb7 <alltraps>

80106deb <vector236>:
.globl vector236
vector236:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $236
80106ded:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106df2:	e9 c0 f1 ff ff       	jmp    80105fb7 <alltraps>

80106df7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $237
80106df9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dfe:	e9 b4 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e03 <vector238>:
.globl vector238
vector238:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $238
80106e05:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e0a:	e9 a8 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e0f <vector239>:
.globl vector239
vector239:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $239
80106e11:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e16:	e9 9c f1 ff ff       	jmp    80105fb7 <alltraps>

80106e1b <vector240>:
.globl vector240
vector240:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $240
80106e1d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e22:	e9 90 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e27 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $241
80106e29:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e2e:	e9 84 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e33 <vector242>:
.globl vector242
vector242:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $242
80106e35:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e3a:	e9 78 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e3f <vector243>:
.globl vector243
vector243:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $243
80106e41:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e46:	e9 6c f1 ff ff       	jmp    80105fb7 <alltraps>

80106e4b <vector244>:
.globl vector244
vector244:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $244
80106e4d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e52:	e9 60 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e57 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $245
80106e59:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e5e:	e9 54 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e63 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $246
80106e65:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e6a:	e9 48 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e6f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $247
80106e71:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e76:	e9 3c f1 ff ff       	jmp    80105fb7 <alltraps>

80106e7b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $248
80106e7d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e82:	e9 30 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e87 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $249
80106e89:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e8e:	e9 24 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e93 <vector250>:
.globl vector250
vector250:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $250
80106e95:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e9a:	e9 18 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e9f <vector251>:
.globl vector251
vector251:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $251
80106ea1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ea6:	e9 0c f1 ff ff       	jmp    80105fb7 <alltraps>

80106eab <vector252>:
.globl vector252
vector252:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $252
80106ead:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106eb2:	e9 00 f1 ff ff       	jmp    80105fb7 <alltraps>

80106eb7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $253
80106eb9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106ebe:	e9 f4 f0 ff ff       	jmp    80105fb7 <alltraps>

80106ec3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $254
80106ec5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106eca:	e9 e8 f0 ff ff       	jmp    80105fb7 <alltraps>

80106ecf <vector255>:
.globl vector255
vector255:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $255
80106ed1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ed6:	e9 dc f0 ff ff       	jmp    80105fb7 <alltraps>
80106edb:	66 90                	xchg   %ax,%ax
80106edd:	66 90                	xchg   %ax,%ax
80106edf:	90                   	nop

80106ee0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ee7:	c1 ea 16             	shr    $0x16,%edx
{
80106eea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106eeb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106eee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ef1:	8b 1f                	mov    (%edi),%ebx
80106ef3:	f6 c3 01             	test   $0x1,%bl
80106ef6:	74 28                	je     80106f20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ef8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106efe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106f04:	89 f0                	mov    %esi,%eax
}
80106f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106f09:	c1 e8 0a             	shr    $0xa,%eax
80106f0c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f11:	01 d8                	add    %ebx,%eax
}
80106f13:	5b                   	pop    %ebx
80106f14:	5e                   	pop    %esi
80106f15:	5f                   	pop    %edi
80106f16:	5d                   	pop    %ebp
80106f17:	c3                   	ret    
80106f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f20:	85 c9                	test   %ecx,%ecx
80106f22:	74 2c                	je     80106f50 <walkpgdir+0x70>
80106f24:	e8 17 b7 ff ff       	call   80102640 <kalloc>
80106f29:	89 c3                	mov    %eax,%ebx
80106f2b:	85 c0                	test   %eax,%eax
80106f2d:	74 21                	je     80106f50 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106f2f:	83 ec 04             	sub    $0x4,%esp
80106f32:	68 00 10 00 00       	push   $0x1000
80106f37:	6a 00                	push   $0x0
80106f39:	50                   	push   %eax
80106f3a:	e8 b1 dd ff ff       	call   80104cf0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f3f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f45:	83 c4 10             	add    $0x10,%esp
80106f48:	83 c8 07             	or     $0x7,%eax
80106f4b:	89 07                	mov    %eax,(%edi)
80106f4d:	eb b5                	jmp    80106f04 <walkpgdir+0x24>
80106f4f:	90                   	nop
}
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f53:	31 c0                	xor    %eax,%eax
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f66:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106f6a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106f70:	89 d6                	mov    %edx,%esi
{
80106f72:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f73:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106f79:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f82:	29 f0                	sub    %esi,%eax
80106f84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f87:	eb 1f                	jmp    80106fa8 <mappages+0x48>
80106f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106f90:	f6 00 01             	testb  $0x1,(%eax)
80106f93:	75 45                	jne    80106fda <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f95:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106f98:	83 cb 01             	or     $0x1,%ebx
80106f9b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106f9d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106fa0:	74 2e                	je     80106fd0 <mappages+0x70>
      break;
    a += PGSIZE;
80106fa2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fab:	b9 01 00 00 00       	mov    $0x1,%ecx
80106fb0:	89 f2                	mov    %esi,%edx
80106fb2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106fb5:	89 f8                	mov    %edi,%eax
80106fb7:	e8 24 ff ff ff       	call   80106ee0 <walkpgdir>
80106fbc:	85 c0                	test   %eax,%eax
80106fbe:	75 d0                	jne    80106f90 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fc8:	5b                   	pop    %ebx
80106fc9:	5e                   	pop    %esi
80106fca:	5f                   	pop    %edi
80106fcb:	5d                   	pop    %ebp
80106fcc:	c3                   	ret    
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi
80106fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fd3:	31 c0                	xor    %eax,%eax
}
80106fd5:	5b                   	pop    %ebx
80106fd6:	5e                   	pop    %esi
80106fd7:	5f                   	pop    %edi
80106fd8:	5d                   	pop    %ebp
80106fd9:	c3                   	ret    
      panic("remap");
80106fda:	83 ec 0c             	sub    $0xc,%esp
80106fdd:	68 ac 81 10 80       	push   $0x801081ac
80106fe2:	e8 a9 93 ff ff       	call   80100390 <panic>
80106fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	89 c6                	mov    %eax,%esi
80106ff7:	53                   	push   %ebx
80106ff8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ffa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107000:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107006:	83 ec 1c             	sub    $0x1c,%esp
80107009:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010700c:	39 da                	cmp    %ebx,%edx
8010700e:	73 5b                	jae    8010706b <deallocuvm.part.0+0x7b>
80107010:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107013:	89 d7                	mov    %edx,%edi
80107015:	eb 14                	jmp    8010702b <deallocuvm.part.0+0x3b>
80107017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701e:	66 90                	xchg   %ax,%ax
80107020:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107026:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107029:	76 40                	jbe    8010706b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010702b:	31 c9                	xor    %ecx,%ecx
8010702d:	89 fa                	mov    %edi,%edx
8010702f:	89 f0                	mov    %esi,%eax
80107031:	e8 aa fe ff ff       	call   80106ee0 <walkpgdir>
80107036:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107038:	85 c0                	test   %eax,%eax
8010703a:	74 44                	je     80107080 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010703c:	8b 00                	mov    (%eax),%eax
8010703e:	a8 01                	test   $0x1,%al
80107040:	74 de                	je     80107020 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107042:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107047:	74 47                	je     80107090 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107049:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010704c:	05 00 00 00 80       	add    $0x80000000,%eax
80107051:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107057:	50                   	push   %eax
80107058:	e8 23 b4 ff ff       	call   80102480 <kfree>
      *pte = 0;
8010705d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107063:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107066:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107069:	77 c0                	ja     8010702b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010706b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010706e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107071:	5b                   	pop    %ebx
80107072:	5e                   	pop    %esi
80107073:	5f                   	pop    %edi
80107074:	5d                   	pop    %ebp
80107075:	c3                   	ret    
80107076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107080:	89 fa                	mov    %edi,%edx
80107082:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107088:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010708e:	eb 96                	jmp    80107026 <deallocuvm.part.0+0x36>
        panic("kfree");
80107090:	83 ec 0c             	sub    $0xc,%esp
80107093:	68 86 7a 10 80       	push   $0x80107a86
80107098:	e8 f3 92 ff ff       	call   80100390 <panic>
8010709d:	8d 76 00             	lea    0x0(%esi),%esi

801070a0 <seginit>:
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
801070a5:	89 e5                	mov    %esp,%ebp
801070a7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070aa:	e8 11 cb ff ff       	call   80103bc0 <cpuid>
  pd[0] = size-1;
801070af:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070b4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070ba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070be:	c7 80 f8 7c 11 80 ff 	movl   $0xffff,-0x7fee8308(%eax)
801070c5:	ff 00 00 
801070c8:	c7 80 fc 7c 11 80 00 	movl   $0xcf9a00,-0x7fee8304(%eax)
801070cf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070d2:	c7 80 00 7d 11 80 ff 	movl   $0xffff,-0x7fee8300(%eax)
801070d9:	ff 00 00 
801070dc:	c7 80 04 7d 11 80 00 	movl   $0xcf9200,-0x7fee82fc(%eax)
801070e3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070e6:	c7 80 08 7d 11 80 ff 	movl   $0xffff,-0x7fee82f8(%eax)
801070ed:	ff 00 00 
801070f0:	c7 80 0c 7d 11 80 00 	movl   $0xcffa00,-0x7fee82f4(%eax)
801070f7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070fa:	c7 80 10 7d 11 80 ff 	movl   $0xffff,-0x7fee82f0(%eax)
80107101:	ff 00 00 
80107104:	c7 80 14 7d 11 80 00 	movl   $0xcff200,-0x7fee82ec(%eax)
8010710b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010710e:	05 f0 7c 11 80       	add    $0x80117cf0,%eax
  pd[1] = (uint)p;
80107113:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107117:	c1 e8 10             	shr    $0x10,%eax
8010711a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010711e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107121:	0f 01 10             	lgdtl  (%eax)
}
80107124:	c9                   	leave  
80107125:	c3                   	ret    
80107126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712d:	8d 76 00             	lea    0x0(%esi),%esi

80107130 <switchkvm>:
{
80107130:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107134:	a1 c4 ae 11 80       	mov    0x8011aec4,%eax
80107139:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010713e:	0f 22 d8             	mov    %eax,%cr3
}
80107141:	c3                   	ret    
80107142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107150 <switchuvm>:
{
80107150:	f3 0f 1e fb          	endbr32 
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	57                   	push   %edi
80107158:	56                   	push   %esi
80107159:	53                   	push   %ebx
8010715a:	83 ec 1c             	sub    $0x1c,%esp
8010715d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107160:	85 f6                	test   %esi,%esi
80107162:	0f 84 cb 00 00 00    	je     80107233 <switchuvm+0xe3>
  if(p->kstack == 0)
80107168:	8b 46 1c             	mov    0x1c(%esi),%eax
8010716b:	85 c0                	test   %eax,%eax
8010716d:	0f 84 da 00 00 00    	je     8010724d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107173:	8b 46 18             	mov    0x18(%esi),%eax
80107176:	85 c0                	test   %eax,%eax
80107178:	0f 84 c2 00 00 00    	je     80107240 <switchuvm+0xf0>
  pushcli();
8010717e:	e8 5d d9 ff ff       	call   80104ae0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107183:	e8 c8 c9 ff ff       	call   80103b50 <mycpu>
80107188:	89 c3                	mov    %eax,%ebx
8010718a:	e8 c1 c9 ff ff       	call   80103b50 <mycpu>
8010718f:	89 c7                	mov    %eax,%edi
80107191:	e8 ba c9 ff ff       	call   80103b50 <mycpu>
80107196:	83 c7 08             	add    $0x8,%edi
80107199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010719c:	e8 af c9 ff ff       	call   80103b50 <mycpu>
801071a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071a4:	ba 67 00 00 00       	mov    $0x67,%edx
801071a9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071b0:	83 c0 08             	add    $0x8,%eax
801071b3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071ba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071bf:	83 c1 08             	add    $0x8,%ecx
801071c2:	c1 e8 18             	shr    $0x18,%eax
801071c5:	c1 e9 10             	shr    $0x10,%ecx
801071c8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801071ce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801071d4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071d9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801071e5:	e8 66 c9 ff ff       	call   80103b50 <mycpu>
801071ea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071f1:	e8 5a c9 ff ff       	call   80103b50 <mycpu>
801071f6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071fa:	8b 5e 1c             	mov    0x1c(%esi),%ebx
801071fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107203:	e8 48 c9 ff ff       	call   80103b50 <mycpu>
80107208:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010720b:	e8 40 c9 ff ff       	call   80103b50 <mycpu>
80107210:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107214:	b8 28 00 00 00       	mov    $0x28,%eax
80107219:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010721c:	8b 46 18             	mov    0x18(%esi),%eax
8010721f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107224:	0f 22 d8             	mov    %eax,%cr3
}
80107227:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010722a:	5b                   	pop    %ebx
8010722b:	5e                   	pop    %esi
8010722c:	5f                   	pop    %edi
8010722d:	5d                   	pop    %ebp
  popcli();
8010722e:	e9 fd d8 ff ff       	jmp    80104b30 <popcli>
    panic("switchuvm: no process");
80107233:	83 ec 0c             	sub    $0xc,%esp
80107236:	68 b2 81 10 80       	push   $0x801081b2
8010723b:	e8 50 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107240:	83 ec 0c             	sub    $0xc,%esp
80107243:	68 dd 81 10 80       	push   $0x801081dd
80107248:	e8 43 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010724d:	83 ec 0c             	sub    $0xc,%esp
80107250:	68 c8 81 10 80       	push   $0x801081c8
80107255:	e8 36 91 ff ff       	call   80100390 <panic>
8010725a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107260 <inituvm>:
{
80107260:	f3 0f 1e fb          	endbr32 
80107264:	55                   	push   %ebp
80107265:	89 e5                	mov    %esp,%ebp
80107267:	57                   	push   %edi
80107268:	56                   	push   %esi
80107269:	53                   	push   %ebx
8010726a:	83 ec 1c             	sub    $0x1c,%esp
8010726d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107270:	8b 75 10             	mov    0x10(%ebp),%esi
80107273:	8b 7d 08             	mov    0x8(%ebp),%edi
80107276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107279:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010727f:	77 4b                	ja     801072cc <inituvm+0x6c>
  mem = kalloc();
80107281:	e8 ba b3 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80107286:	83 ec 04             	sub    $0x4,%esp
80107289:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010728e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107290:	6a 00                	push   $0x0
80107292:	50                   	push   %eax
80107293:	e8 58 da ff ff       	call   80104cf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107298:	58                   	pop    %eax
80107299:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010729f:	5a                   	pop    %edx
801072a0:	6a 06                	push   $0x6
801072a2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072a7:	31 d2                	xor    %edx,%edx
801072a9:	50                   	push   %eax
801072aa:	89 f8                	mov    %edi,%eax
801072ac:	e8 af fc ff ff       	call   80106f60 <mappages>
  memmove(mem, init, sz);
801072b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072b4:	89 75 10             	mov    %esi,0x10(%ebp)
801072b7:	83 c4 10             	add    $0x10,%esp
801072ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
801072bd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c3:	5b                   	pop    %ebx
801072c4:	5e                   	pop    %esi
801072c5:	5f                   	pop    %edi
801072c6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072c7:	e9 c4 da ff ff       	jmp    80104d90 <memmove>
    panic("inituvm: more than a page");
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	68 f1 81 10 80       	push   $0x801081f1
801072d4:	e8 b7 90 ff ff       	call   80100390 <panic>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <loaduvm>:
{
801072e0:	f3 0f 1e fb          	endbr32 
801072e4:	55                   	push   %ebp
801072e5:	89 e5                	mov    %esp,%ebp
801072e7:	57                   	push   %edi
801072e8:	56                   	push   %esi
801072e9:	53                   	push   %ebx
801072ea:	83 ec 1c             	sub    $0x1c,%esp
801072ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801072f0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801072f3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801072f8:	0f 85 99 00 00 00    	jne    80107397 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801072fe:	01 f0                	add    %esi,%eax
80107300:	89 f3                	mov    %esi,%ebx
80107302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107305:	8b 45 14             	mov    0x14(%ebp),%eax
80107308:	01 f0                	add    %esi,%eax
8010730a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010730d:	85 f6                	test   %esi,%esi
8010730f:	75 15                	jne    80107326 <loaduvm+0x46>
80107311:	eb 6d                	jmp    80107380 <loaduvm+0xa0>
80107313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107317:	90                   	nop
80107318:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010731e:	89 f0                	mov    %esi,%eax
80107320:	29 d8                	sub    %ebx,%eax
80107322:	39 c6                	cmp    %eax,%esi
80107324:	76 5a                	jbe    80107380 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107326:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107329:	8b 45 08             	mov    0x8(%ebp),%eax
8010732c:	31 c9                	xor    %ecx,%ecx
8010732e:	29 da                	sub    %ebx,%edx
80107330:	e8 ab fb ff ff       	call   80106ee0 <walkpgdir>
80107335:	85 c0                	test   %eax,%eax
80107337:	74 51                	je     8010738a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107339:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010733b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010733e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107343:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107348:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010734e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107351:	29 d9                	sub    %ebx,%ecx
80107353:	05 00 00 00 80       	add    $0x80000000,%eax
80107358:	57                   	push   %edi
80107359:	51                   	push   %ecx
8010735a:	50                   	push   %eax
8010735b:	ff 75 10             	pushl  0x10(%ebp)
8010735e:	e8 0d a7 ff ff       	call   80101a70 <readi>
80107363:	83 c4 10             	add    $0x10,%esp
80107366:	39 f8                	cmp    %edi,%eax
80107368:	74 ae                	je     80107318 <loaduvm+0x38>
}
8010736a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010736d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107372:	5b                   	pop    %ebx
80107373:	5e                   	pop    %esi
80107374:	5f                   	pop    %edi
80107375:	5d                   	pop    %ebp
80107376:	c3                   	ret    
80107377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737e:	66 90                	xchg   %ax,%ax
80107380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107383:	31 c0                	xor    %eax,%eax
}
80107385:	5b                   	pop    %ebx
80107386:	5e                   	pop    %esi
80107387:	5f                   	pop    %edi
80107388:	5d                   	pop    %ebp
80107389:	c3                   	ret    
      panic("loaduvm: address should exist");
8010738a:	83 ec 0c             	sub    $0xc,%esp
8010738d:	68 0b 82 10 80       	push   $0x8010820b
80107392:	e8 f9 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107397:	83 ec 0c             	sub    $0xc,%esp
8010739a:	68 ac 82 10 80       	push   $0x801082ac
8010739f:	e8 ec 8f ff ff       	call   80100390 <panic>
801073a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop

801073b0 <allocuvm>:
{
801073b0:	f3 0f 1e fb          	endbr32 
801073b4:	55                   	push   %ebp
801073b5:	89 e5                	mov    %esp,%ebp
801073b7:	57                   	push   %edi
801073b8:	56                   	push   %esi
801073b9:	53                   	push   %ebx
801073ba:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073bd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801073c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801073c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073c6:	85 c0                	test   %eax,%eax
801073c8:	0f 88 b2 00 00 00    	js     80107480 <allocuvm+0xd0>
  if(newsz < oldsz)
801073ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801073d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801073d4:	0f 82 96 00 00 00    	jb     80107470 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801073da:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801073e0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801073e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073e9:	77 40                	ja     8010742b <allocuvm+0x7b>
801073eb:	e9 83 00 00 00       	jmp    80107473 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801073f0:	83 ec 04             	sub    $0x4,%esp
801073f3:	68 00 10 00 00       	push   $0x1000
801073f8:	6a 00                	push   $0x0
801073fa:	50                   	push   %eax
801073fb:	e8 f0 d8 ff ff       	call   80104cf0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107400:	58                   	pop    %eax
80107401:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107407:	5a                   	pop    %edx
80107408:	6a 06                	push   $0x6
8010740a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010740f:	89 f2                	mov    %esi,%edx
80107411:	50                   	push   %eax
80107412:	89 f8                	mov    %edi,%eax
80107414:	e8 47 fb ff ff       	call   80106f60 <mappages>
80107419:	83 c4 10             	add    $0x10,%esp
8010741c:	85 c0                	test   %eax,%eax
8010741e:	78 78                	js     80107498 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107420:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107426:	39 75 10             	cmp    %esi,0x10(%ebp)
80107429:	76 48                	jbe    80107473 <allocuvm+0xc3>
    mem = kalloc();
8010742b:	e8 10 b2 ff ff       	call   80102640 <kalloc>
80107430:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107432:	85 c0                	test   %eax,%eax
80107434:	75 ba                	jne    801073f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107436:	83 ec 0c             	sub    $0xc,%esp
80107439:	68 29 82 10 80       	push   $0x80108229
8010743e:	e8 6d 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107443:	8b 45 0c             	mov    0xc(%ebp),%eax
80107446:	83 c4 10             	add    $0x10,%esp
80107449:	39 45 10             	cmp    %eax,0x10(%ebp)
8010744c:	74 32                	je     80107480 <allocuvm+0xd0>
8010744e:	8b 55 10             	mov    0x10(%ebp),%edx
80107451:	89 c1                	mov    %eax,%ecx
80107453:	89 f8                	mov    %edi,%eax
80107455:	e8 96 fb ff ff       	call   80106ff0 <deallocuvm.part.0>
      return 0;
8010745a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107464:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107467:	5b                   	pop    %ebx
80107468:	5e                   	pop    %esi
80107469:	5f                   	pop    %edi
8010746a:	5d                   	pop    %ebp
8010746b:	c3                   	ret    
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107479:	5b                   	pop    %ebx
8010747a:	5e                   	pop    %esi
8010747b:	5f                   	pop    %edi
8010747c:	5d                   	pop    %ebp
8010747d:	c3                   	ret    
8010747e:	66 90                	xchg   %ax,%ax
    return 0;
80107480:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010748a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010748d:	5b                   	pop    %ebx
8010748e:	5e                   	pop    %esi
8010748f:	5f                   	pop    %edi
80107490:	5d                   	pop    %ebp
80107491:	c3                   	ret    
80107492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	68 41 82 10 80       	push   $0x80108241
801074a0:	e8 0b 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801074a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074a8:	83 c4 10             	add    $0x10,%esp
801074ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ae:	74 0c                	je     801074bc <allocuvm+0x10c>
801074b0:	8b 55 10             	mov    0x10(%ebp),%edx
801074b3:	89 c1                	mov    %eax,%ecx
801074b5:	89 f8                	mov    %edi,%eax
801074b7:	e8 34 fb ff ff       	call   80106ff0 <deallocuvm.part.0>
      kfree(mem);
801074bc:	83 ec 0c             	sub    $0xc,%esp
801074bf:	53                   	push   %ebx
801074c0:	e8 bb af ff ff       	call   80102480 <kfree>
      return 0;
801074c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801074cc:	83 c4 10             	add    $0x10,%esp
}
801074cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d5:	5b                   	pop    %ebx
801074d6:	5e                   	pop    %esi
801074d7:	5f                   	pop    %edi
801074d8:	5d                   	pop    %ebp
801074d9:	c3                   	ret    
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074e0 <deallocuvm>:
{
801074e0:	f3 0f 1e fb          	endbr32 
801074e4:	55                   	push   %ebp
801074e5:	89 e5                	mov    %esp,%ebp
801074e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
801074ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801074f0:	39 d1                	cmp    %edx,%ecx
801074f2:	73 0c                	jae    80107500 <deallocuvm+0x20>
}
801074f4:	5d                   	pop    %ebp
801074f5:	e9 f6 fa ff ff       	jmp    80106ff0 <deallocuvm.part.0>
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107500:	89 d0                	mov    %edx,%eax
80107502:	5d                   	pop    %ebp
80107503:	c3                   	ret    
80107504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010750f:	90                   	nop

80107510 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107510:	f3 0f 1e fb          	endbr32 
80107514:	55                   	push   %ebp
80107515:	89 e5                	mov    %esp,%ebp
80107517:	57                   	push   %edi
80107518:	56                   	push   %esi
80107519:	53                   	push   %ebx
8010751a:	83 ec 0c             	sub    $0xc,%esp
8010751d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107520:	85 f6                	test   %esi,%esi
80107522:	74 55                	je     80107579 <freevm+0x69>
  if(newsz >= oldsz)
80107524:	31 c9                	xor    %ecx,%ecx
80107526:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010752b:	89 f0                	mov    %esi,%eax
8010752d:	89 f3                	mov    %esi,%ebx
8010752f:	e8 bc fa ff ff       	call   80106ff0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107534:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010753a:	eb 0b                	jmp    80107547 <freevm+0x37>
8010753c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107540:	83 c3 04             	add    $0x4,%ebx
80107543:	39 df                	cmp    %ebx,%edi
80107545:	74 23                	je     8010756a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107547:	8b 03                	mov    (%ebx),%eax
80107549:	a8 01                	test   $0x1,%al
8010754b:	74 f3                	je     80107540 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010754d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107552:	83 ec 0c             	sub    $0xc,%esp
80107555:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107558:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010755d:	50                   	push   %eax
8010755e:	e8 1d af ff ff       	call   80102480 <kfree>
80107563:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107566:	39 df                	cmp    %ebx,%edi
80107568:	75 dd                	jne    80107547 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010756a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010756d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107570:	5b                   	pop    %ebx
80107571:	5e                   	pop    %esi
80107572:	5f                   	pop    %edi
80107573:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107574:	e9 07 af ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80107579:	83 ec 0c             	sub    $0xc,%esp
8010757c:	68 5d 82 10 80       	push   $0x8010825d
80107581:	e8 0a 8e ff ff       	call   80100390 <panic>
80107586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758d:	8d 76 00             	lea    0x0(%esi),%esi

80107590 <setupkvm>:
{
80107590:	f3 0f 1e fb          	endbr32 
80107594:	55                   	push   %ebp
80107595:	89 e5                	mov    %esp,%ebp
80107597:	56                   	push   %esi
80107598:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107599:	e8 a2 b0 ff ff       	call   80102640 <kalloc>
8010759e:	89 c6                	mov    %eax,%esi
801075a0:	85 c0                	test   %eax,%eax
801075a2:	74 42                	je     801075e6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801075a4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075a7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075ac:	68 00 10 00 00       	push   $0x1000
801075b1:	6a 00                	push   $0x0
801075b3:	50                   	push   %eax
801075b4:	e8 37 d7 ff ff       	call   80104cf0 <memset>
801075b9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075bc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075bf:	83 ec 08             	sub    $0x8,%esp
801075c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075c5:	ff 73 0c             	pushl  0xc(%ebx)
801075c8:	8b 13                	mov    (%ebx),%edx
801075ca:	50                   	push   %eax
801075cb:	29 c1                	sub    %eax,%ecx
801075cd:	89 f0                	mov    %esi,%eax
801075cf:	e8 8c f9 ff ff       	call   80106f60 <mappages>
801075d4:	83 c4 10             	add    $0x10,%esp
801075d7:	85 c0                	test   %eax,%eax
801075d9:	78 15                	js     801075f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075db:	83 c3 10             	add    $0x10,%ebx
801075de:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801075e4:	75 d6                	jne    801075bc <setupkvm+0x2c>
}
801075e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075e9:	89 f0                	mov    %esi,%eax
801075eb:	5b                   	pop    %ebx
801075ec:	5e                   	pop    %esi
801075ed:	5d                   	pop    %ebp
801075ee:	c3                   	ret    
801075ef:	90                   	nop
      freevm(pgdir);
801075f0:	83 ec 0c             	sub    $0xc,%esp
801075f3:	56                   	push   %esi
      return 0;
801075f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801075f6:	e8 15 ff ff ff       	call   80107510 <freevm>
      return 0;
801075fb:	83 c4 10             	add    $0x10,%esp
}
801075fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107601:	89 f0                	mov    %esi,%eax
80107603:	5b                   	pop    %ebx
80107604:	5e                   	pop    %esi
80107605:	5d                   	pop    %ebp
80107606:	c3                   	ret    
80107607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760e:	66 90                	xchg   %ax,%ax

80107610 <kvmalloc>:
{
80107610:	f3 0f 1e fb          	endbr32 
80107614:	55                   	push   %ebp
80107615:	89 e5                	mov    %esp,%ebp
80107617:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010761a:	e8 71 ff ff ff       	call   80107590 <setupkvm>
8010761f:	a3 c4 ae 11 80       	mov    %eax,0x8011aec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107624:	05 00 00 00 80       	add    $0x80000000,%eax
80107629:	0f 22 d8             	mov    %eax,%cr3
}
8010762c:	c9                   	leave  
8010762d:	c3                   	ret    
8010762e:	66 90                	xchg   %ax,%ax

80107630 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107630:	f3 0f 1e fb          	endbr32 
80107634:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107635:	31 c9                	xor    %ecx,%ecx
{
80107637:	89 e5                	mov    %esp,%ebp
80107639:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010763c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010763f:	8b 45 08             	mov    0x8(%ebp),%eax
80107642:	e8 99 f8 ff ff       	call   80106ee0 <walkpgdir>
  if(pte == 0)
80107647:	85 c0                	test   %eax,%eax
80107649:	74 05                	je     80107650 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010764b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010764e:	c9                   	leave  
8010764f:	c3                   	ret    
    panic("clearpteu");
80107650:	83 ec 0c             	sub    $0xc,%esp
80107653:	68 6e 82 10 80       	push   $0x8010826e
80107658:	e8 33 8d ff ff       	call   80100390 <panic>
8010765d:	8d 76 00             	lea    0x0(%esi),%esi

80107660 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107660:	f3 0f 1e fb          	endbr32 
80107664:	55                   	push   %ebp
80107665:	89 e5                	mov    %esp,%ebp
80107667:	57                   	push   %edi
80107668:	56                   	push   %esi
80107669:	53                   	push   %ebx
8010766a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010766d:	e8 1e ff ff ff       	call   80107590 <setupkvm>
80107672:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107675:	85 c0                	test   %eax,%eax
80107677:	0f 84 9b 00 00 00    	je     80107718 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010767d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107680:	85 c9                	test   %ecx,%ecx
80107682:	0f 84 90 00 00 00    	je     80107718 <copyuvm+0xb8>
80107688:	31 f6                	xor    %esi,%esi
8010768a:	eb 46                	jmp    801076d2 <copyuvm+0x72>
8010768c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107690:	83 ec 04             	sub    $0x4,%esp
80107693:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107699:	68 00 10 00 00       	push   $0x1000
8010769e:	57                   	push   %edi
8010769f:	50                   	push   %eax
801076a0:	e8 eb d6 ff ff       	call   80104d90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076a5:	58                   	pop    %eax
801076a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076ac:	5a                   	pop    %edx
801076ad:	ff 75 e4             	pushl  -0x1c(%ebp)
801076b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076b5:	89 f2                	mov    %esi,%edx
801076b7:	50                   	push   %eax
801076b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076bb:	e8 a0 f8 ff ff       	call   80106f60 <mappages>
801076c0:	83 c4 10             	add    $0x10,%esp
801076c3:	85 c0                	test   %eax,%eax
801076c5:	78 61                	js     80107728 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801076c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076d0:	76 46                	jbe    80107718 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076d2:	8b 45 08             	mov    0x8(%ebp),%eax
801076d5:	31 c9                	xor    %ecx,%ecx
801076d7:	89 f2                	mov    %esi,%edx
801076d9:	e8 02 f8 ff ff       	call   80106ee0 <walkpgdir>
801076de:	85 c0                	test   %eax,%eax
801076e0:	74 61                	je     80107743 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801076e2:	8b 00                	mov    (%eax),%eax
801076e4:	a8 01                	test   $0x1,%al
801076e6:	74 4e                	je     80107736 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801076e8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076ea:	25 ff 0f 00 00       	and    $0xfff,%eax
801076ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801076f2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801076f8:	e8 43 af ff ff       	call   80102640 <kalloc>
801076fd:	89 c3                	mov    %eax,%ebx
801076ff:	85 c0                	test   %eax,%eax
80107701:	75 8d                	jne    80107690 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107703:	83 ec 0c             	sub    $0xc,%esp
80107706:	ff 75 e0             	pushl  -0x20(%ebp)
80107709:	e8 02 fe ff ff       	call   80107510 <freevm>
  return 0;
8010770e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107715:	83 c4 10             	add    $0x10,%esp
}
80107718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010771b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010771e:	5b                   	pop    %ebx
8010771f:	5e                   	pop    %esi
80107720:	5f                   	pop    %edi
80107721:	5d                   	pop    %ebp
80107722:	c3                   	ret    
80107723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107727:	90                   	nop
      kfree(mem);
80107728:	83 ec 0c             	sub    $0xc,%esp
8010772b:	53                   	push   %ebx
8010772c:	e8 4f ad ff ff       	call   80102480 <kfree>
      goto bad;
80107731:	83 c4 10             	add    $0x10,%esp
80107734:	eb cd                	jmp    80107703 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107736:	83 ec 0c             	sub    $0xc,%esp
80107739:	68 92 82 10 80       	push   $0x80108292
8010773e:	e8 4d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107743:	83 ec 0c             	sub    $0xc,%esp
80107746:	68 78 82 10 80       	push   $0x80108278
8010774b:	e8 40 8c ff ff       	call   80100390 <panic>

80107750 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107755:	31 c9                	xor    %ecx,%ecx
{
80107757:	89 e5                	mov    %esp,%ebp
80107759:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010775c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010775f:	8b 45 08             	mov    0x8(%ebp),%eax
80107762:	e8 79 f7 ff ff       	call   80106ee0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107767:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107769:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010776a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010776c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107771:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107774:	05 00 00 00 80       	add    $0x80000000,%eax
80107779:	83 fa 05             	cmp    $0x5,%edx
8010777c:	ba 00 00 00 00       	mov    $0x0,%edx
80107781:	0f 45 c2             	cmovne %edx,%eax
}
80107784:	c3                   	ret    
80107785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107790 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107790:	f3 0f 1e fb          	endbr32 
80107794:	55                   	push   %ebp
80107795:	89 e5                	mov    %esp,%ebp
80107797:	57                   	push   %edi
80107798:	56                   	push   %esi
80107799:	53                   	push   %ebx
8010779a:	83 ec 0c             	sub    $0xc,%esp
8010779d:	8b 75 14             	mov    0x14(%ebp),%esi
801077a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077a3:	85 f6                	test   %esi,%esi
801077a5:	75 3c                	jne    801077e3 <copyout+0x53>
801077a7:	eb 67                	jmp    80107810 <copyout+0x80>
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801077b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801077b3:	89 fb                	mov    %edi,%ebx
801077b5:	29 d3                	sub    %edx,%ebx
801077b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801077bd:	39 f3                	cmp    %esi,%ebx
801077bf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077c2:	29 fa                	sub    %edi,%edx
801077c4:	83 ec 04             	sub    $0x4,%esp
801077c7:	01 c2                	add    %eax,%edx
801077c9:	53                   	push   %ebx
801077ca:	ff 75 10             	pushl  0x10(%ebp)
801077cd:	52                   	push   %edx
801077ce:	e8 bd d5 ff ff       	call   80104d90 <memmove>
    len -= n;
    buf += n;
801077d3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801077d6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801077dc:	83 c4 10             	add    $0x10,%esp
801077df:	29 de                	sub    %ebx,%esi
801077e1:	74 2d                	je     80107810 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801077e3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801077e5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801077e8:	89 55 0c             	mov    %edx,0xc(%ebp)
801077eb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801077f1:	57                   	push   %edi
801077f2:	ff 75 08             	pushl  0x8(%ebp)
801077f5:	e8 56 ff ff ff       	call   80107750 <uva2ka>
    if(pa0 == 0)
801077fa:	83 c4 10             	add    $0x10,%esp
801077fd:	85 c0                	test   %eax,%eax
801077ff:	75 af                	jne    801077b0 <copyout+0x20>
  }
  return 0;
}
80107801:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107809:	5b                   	pop    %ebx
8010780a:	5e                   	pop    %esi
8010780b:	5f                   	pop    %edi
8010780c:	5d                   	pop    %ebp
8010780d:	c3                   	ret    
8010780e:	66 90                	xchg   %ax,%ax
80107810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107813:	31 c0                	xor    %eax,%eax
}
80107815:	5b                   	pop    %ebx
80107816:	5e                   	pop    %esi
80107817:	5f                   	pop    %edi
80107818:	5d                   	pop    %ebp
80107819:	c3                   	ret    
