
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
80100050:	68 e0 78 10 80       	push   $0x801078e0
80100055:	68 c0 0a 11 80       	push   $0x80110ac0
8010005a:	e8 61 4a 00 00       	call   80104ac0 <initlock>
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
80100092:	68 e7 78 10 80       	push   $0x801078e7
80100097:	50                   	push   %eax
80100098:	e8 e3 48 00 00       	call   80104980 <initsleeplock>
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
801000e8:	e8 53 4b 00 00       	call   80104c40 <acquire>
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
80100162:	e8 99 4b 00 00       	call   80104d00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 48 00 00       	call   801049c0 <acquiresleep>
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
801001a3:	68 ee 78 10 80       	push   $0x801078ee
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
801001c2:	e8 99 48 00 00       	call   80104a60 <holdingsleep>
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
801001e0:	68 ff 78 10 80       	push   $0x801078ff
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
80100203:	e8 58 48 00 00       	call   80104a60 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 48 00 00       	call   80104a20 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 0a 11 80 	movl   $0x80110ac0,(%esp)
8010021f:	e8 1c 4a 00 00       	call   80104c40 <acquire>
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
80100270:	e9 8b 4a 00 00       	jmp    80104d00 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 79 10 80       	push   $0x80107906
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
801002b1:	e8 8a 49 00 00       	call   80104c40 <acquire>
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
8010030e:	e8 ed 49 00 00       	call   80104d00 <release>
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
80100365:	e8 96 49 00 00       	call   80104d00 <release>
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
801003b6:	68 0d 79 10 80       	push   $0x8010790d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 eb 7e 10 80 	movl   $0x80107eeb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 46 00 00       	call   80104ae0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 79 10 80       	push   $0x80107921
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
8010042a:	e8 b1 60 00 00       	call   801064e0 <uartputc>
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
80100515:	e8 c6 5f 00 00       	call   801064e0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 5f 00 00       	call   801064e0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 5f 00 00       	call   801064e0 <uartputc>
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
80100561:	e8 8a 48 00 00       	call   80104df0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 47 00 00       	call   80104d50 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 79 10 80       	push   $0x80107925
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
801005c9:	0f b6 92 50 79 10 80 	movzbl -0x7fef86b0(%edx),%edx
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
8010065f:	e8 dc 45 00 00       	call   80104c40 <acquire>
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
80100697:	e8 64 46 00 00       	call   80104d00 <release>
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
8010077d:	bb 38 79 10 80       	mov    $0x80107938,%ebx
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
801007bd:	e8 7e 44 00 00       	call   80104c40 <acquire>
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
80100828:	e8 d3 44 00 00       	call   80104d00 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 79 10 80       	push   $0x8010793f
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
80100877:	e8 c4 43 00 00       	call   80104c40 <acquire>
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
801009cf:	e8 2c 43 00 00       	call   80104d00 <release>
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
80100a3a:	68 48 79 10 80       	push   $0x80107948
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 77 40 00 00       	call   80104ac0 <initlock>

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
80100b0c:	e8 3f 6b 00 00       	call   80107650 <setupkvm>
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
80100b73:	e8 f8 68 00 00       	call   80107470 <allocuvm>
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
80100ba9:	e8 f2 67 00 00       	call   801073a0 <loaduvm>
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
80100beb:	e8 e0 69 00 00       	call   801075d0 <freevm>
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
80100c32:	e8 39 68 00 00       	call   80107470 <allocuvm>
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
80100c53:	e8 98 6a 00 00       	call   801076f0 <clearpteu>
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
80100ca3:	e8 a8 42 00 00       	call   80104f50 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 95 42 00 00       	call   80104f50 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 84 6b 00 00       	call   80107850 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ea 68 00 00       	call   801075d0 <freevm>
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
80100d33:	e8 18 6b 00 00       	call   80107850 <copyout>
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
80100d71:	e8 9a 41 00 00       	call   80104f10 <safestrcpy>
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
80100da5:	e8 66 64 00 00       	call   80107210 <switchuvm>
  freevm(oldpgdir);
80100daa:	89 3c 24             	mov    %edi,(%esp)
80100dad:	e8 1e 68 00 00       	call   801075d0 <freevm>
  return 0;
80100db2:	83 c4 10             	add    $0x10,%esp
80100db5:	31 c0                	xor    %eax,%eax
80100db7:	e9 34 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dbc:	e8 ef 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	68 61 79 10 80       	push   $0x80107961
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
80100dfa:	68 6d 79 10 80       	push   $0x8010796d
80100dff:	68 c0 54 11 80       	push   $0x801154c0
80100e04:	e8 b7 3c 00 00       	call   80104ac0 <initlock>
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
80100e25:	e8 16 3e 00 00       	call   80104c40 <acquire>
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
80100e51:	e8 aa 3e 00 00       	call   80104d00 <release>
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
80100e6a:	e8 91 3e 00 00       	call   80104d00 <release>
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
80100e93:	e8 a8 3d 00 00       	call   80104c40 <acquire>
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
80100eb0:	e8 4b 3e 00 00       	call   80104d00 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 74 79 10 80       	push   $0x80107974
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
80100ee5:	e8 56 3d 00 00       	call   80104c40 <acquire>
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
80100f20:	e8 db 3d 00 00       	call   80104d00 <release>

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
80100f4e:	e9 ad 3d 00 00       	jmp    80104d00 <release>
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
80100f9c:	68 7c 79 10 80       	push   $0x8010797c
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
8010108a:	68 86 79 10 80       	push   $0x80107986
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
80101173:	68 8f 79 10 80       	push   $0x8010798f
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
801011a9:	68 95 79 10 80       	push   $0x80107995
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
80101227:	68 9f 79 10 80       	push   $0x8010799f
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
801012e4:	68 b2 79 10 80       	push   $0x801079b2
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
80101325:	e8 26 3a 00 00       	call   80104d50 <memset>
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
8010136a:	e8 d1 38 00 00       	call   80104c40 <acquire>
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
801013d7:	e8 24 39 00 00       	call   80104d00 <release>

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
80101405:	e8 f6 38 00 00       	call   80104d00 <release>
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
80101432:	68 c8 79 10 80       	push   $0x801079c8
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
801014fb:	68 d8 79 10 80       	push   $0x801079d8
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
80101535:	e8 b6 38 00 00       	call   80104df0 <memmove>
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
80101560:	68 eb 79 10 80       	push   $0x801079eb
80101565:	68 e0 5e 11 80       	push   $0x80115ee0
8010156a:	e8 51 35 00 00       	call   80104ac0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 f2 79 10 80       	push   $0x801079f2
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 f4 33 00 00       	call   80104980 <initsleeplock>
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
801015d1:	68 58 7a 10 80       	push   $0x80107a58
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
8010166e:	e8 dd 36 00 00       	call   80104d50 <memset>
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
801016a3:	68 f8 79 10 80       	push   $0x801079f8
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
80101715:	e8 d6 36 00 00       	call   80104df0 <memmove>
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
80101753:	e8 e8 34 00 00       	call   80104c40 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80101763:	e8 98 35 00 00       	call   80104d00 <release>
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
80101796:	e8 25 32 00 00       	call   801049c0 <acquiresleep>
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
80101808:	e8 e3 35 00 00       	call   80104df0 <memmove>
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
8010182d:	68 10 7a 10 80       	push   $0x80107a10
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 0a 7a 10 80       	push   $0x80107a0a
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
80101867:	e8 f4 31 00 00       	call   80104a60 <holdingsleep>
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
80101883:	e9 98 31 00 00       	jmp    80104a20 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 1f 7a 10 80       	push   $0x80107a1f
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
801018b4:	e8 07 31 00 00       	call   801049c0 <acquiresleep>
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
801018ce:	e8 4d 31 00 00       	call   80104a20 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
801018da:	e8 61 33 00 00       	call   80104c40 <acquire>
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
801018f4:	e9 07 34 00 00       	jmp    80104d00 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 5e 11 80       	push   $0x80115ee0
80101908:	e8 33 33 00 00       	call   80104c40 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80101917:	e8 e4 33 00 00       	call   80104d00 <release>
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
80101b17:	e8 d4 32 00 00       	call   80104df0 <memmove>
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
80101c13:	e8 d8 31 00 00       	call   80104df0 <memmove>
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
80101cb2:	e8 a9 31 00 00       	call   80104e60 <strncmp>
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
80101d15:	e8 46 31 00 00       	call   80104e60 <strncmp>
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
80101d5a:	68 39 7a 10 80       	push   $0x80107a39
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 27 7a 10 80       	push   $0x80107a27
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
80101dac:	e8 8f 2e 00 00       	call   80104c40 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80101dbc:	e8 3f 2f 00 00       	call   80104d00 <release>
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
80101e27:	e8 c4 2f 00 00       	call   80104df0 <memmove>
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
80101eb3:	e8 38 2f 00 00       	call   80104df0 <memmove>
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
80101fe5:	e8 c6 2e 00 00       	call   80104eb0 <strncpy>
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
80102023:	68 48 7a 10 80       	push   $0x80107a48
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 f2 80 10 80       	push   $0x801080f2
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
8010213b:	68 b4 7a 10 80       	push   $0x80107ab4
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 ab 7a 10 80       	push   $0x80107aab
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
8010216a:	68 c6 7a 10 80       	push   $0x80107ac6
8010216f:	68 80 b5 10 80       	push   $0x8010b580
80102174:	e8 47 29 00 00       	call   80104ac0 <initlock>
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
80102202:	e8 39 2a 00 00       	call   80104c40 <acquire>

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
8010227b:	e8 80 2a 00 00       	call   80104d00 <release>

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
801022a2:	e8 b9 27 00 00       	call   80104a60 <holdingsleep>
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
801022dc:	e8 5f 29 00 00       	call   80104c40 <acquire>

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
80102346:	e9 b5 29 00 00       	jmp    80104d00 <release>
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
8010236a:	68 f5 7a 10 80       	push   $0x80107af5
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 e0 7a 10 80       	push   $0x80107ae0
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 ca 7a 10 80       	push   $0x80107aca
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
801023de:	68 14 7b 10 80       	push   $0x80107b14
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
801024b6:	e8 95 28 00 00       	call   80104d50 <memset>

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
801024f0:	e8 4b 27 00 00       	call   80104c40 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 7b 11 80 	movl   $0x80117b40,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 f0 27 00 00       	jmp    80104d00 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 46 7b 10 80       	push   $0x80107b46
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
8010257f:	68 4c 7b 10 80       	push   $0x80107b4c
80102584:	68 40 7b 11 80       	push   $0x80117b40
80102589:	e8 32 25 00 00       	call   80104ac0 <initlock>
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
80102673:	e8 c8 25 00 00       	call   80104c40 <acquire>
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
801026a1:	e8 5a 26 00 00       	call   80104d00 <release>
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
801026ef:	0f b6 8a 80 7c 10 80 	movzbl -0x7fef8380(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 80 7b 10 80 	movzbl -0x7fef8480(%edx),%eax
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
8010270f:	8b 04 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%eax
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
8010274a:	0f b6 8a 80 7c 10 80 	movzbl -0x7fef8380(%edx),%ecx
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
80102acf:	e8 cc 22 00 00       	call   80104da0 <memcmp>
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
80102c04:	e8 e7 21 00 00       	call   80104df0 <memmove>
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
80102cae:	68 80 7d 10 80       	push   $0x80107d80
80102cb3:	68 80 7b 11 80       	push   $0x80117b80
80102cb8:	e8 03 1e 00 00       	call   80104ac0 <initlock>
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
80102d4f:	e8 ec 1e 00 00       	call   80104c40 <acquire>
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
80102da4:	e8 57 1f 00 00       	call   80104d00 <release>
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
80102dc2:	e8 79 1e 00 00       	call   80104c40 <acquire>
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
80102e00:	e8 fb 1e 00 00       	call   80104d00 <release>
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
80102e1a:	e8 21 1e 00 00       	call   80104c40 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 7b 11 80 	movl   $0x80117b80,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 7b 11 80 00 	movl   $0x0,0x80117bc0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 3b 17 00 00       	call   80104570 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 7b 11 80 	movl   $0x80117b80,(%esp)
80102e3c:	e8 bf 1e 00 00       	call   80104d00 <release>
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
80102e94:	e8 57 1f 00 00       	call   80104df0 <memmove>
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
80102ef4:	e8 07 1e 00 00       	call   80104d00 <release>
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
80102f07:	68 84 7d 10 80       	push   $0x80107d84
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
80102f62:	e8 d9 1c 00 00       	call   80104c40 <acquire>
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
80102fa5:	e9 56 1d 00 00       	jmp    80104d00 <release>
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
80102fd1:	68 93 7d 10 80       	push   $0x80107d93
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 a9 7d 10 80       	push   $0x80107da9
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
80103008:	68 c4 7d 10 80       	push   $0x80107dc4
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 09 31 00 00       	call   80106120 <idtinit>
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
8010303a:	e8 b1 41 00 00       	call   801071f0 <switchkvm>
  seginit();
8010303f:	e8 1c 41 00 00       	call   80107160 <seginit>
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
80103075:	e8 56 46 00 00       	call   801076d0 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 d7 40 00 00       	call   80107160 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 83 33 00 00       	call   80106420 <uartinit>
  pinit();         // process table
8010309d:	e8 8e 0a 00 00       	call   80103b30 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 f9 2f 00 00       	call   801060a0 <tvinit>
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
801030c8:	e8 23 1d 00 00       	call   80104df0 <memmove>

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
801031ae:	68 d8 7d 10 80       	push   $0x80107dd8
801031b3:	56                   	push   %esi
801031b4:	e8 e7 1b 00 00       	call   80104da0 <memcmp>
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
8010326a:	68 dd 7d 10 80       	push   $0x80107ddd
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 28 1b 00 00       	call   80104da0 <memcmp>
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
801033c3:	68 e2 7d 10 80       	push   $0x80107de2
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 fc 7d 10 80       	push   $0x80107dfc
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
80103477:	68 1b 7e 10 80       	push   $0x80107e1b
8010347c:	50                   	push   %eax
8010347d:	e8 3e 16 00 00       	call   80104ac0 <initlock>
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
80103523:	e8 18 17 00 00       	call   80104c40 <acquire>
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
80103568:	e9 93 17 00 00       	jmp    80104d00 <release>
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
80103594:	e8 67 17 00 00       	call   80104d00 <release>
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
801035c1:	e8 7a 16 00 00       	call   80104c40 <acquire>
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
8010364c:	e8 af 16 00 00       	call   80104d00 <release>
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
801036a2:	e8 59 16 00 00       	call   80104d00 <release>
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
801036ca:	e8 71 15 00 00       	call   80104c40 <acquire>
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
8010376e:	e8 8d 15 00 00       	call   80104d00 <release>
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
80103789:	e8 72 15 00 00       	call   80104d00 <release>
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
801037b1:	e8 8a 14 00 00       	call   80104c40 <acquire>
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
80103800:	e8 fb 14 00 00       	call   80104d00 <release>

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
80103825:	c7 40 14 87 60 10 80 	movl   $0x80106087,0x14(%eax)
  p->context = (struct context*)sp;
8010382c:	89 43 30             	mov    %eax,0x30(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010382f:	6a 14                	push   $0x14
80103831:	6a 00                	push   $0x0
80103833:	50                   	push   %eax
80103834:	e8 17 15 00 00       	call   80104d50 <memset>
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
8010385a:	e8 a1 14 00 00       	call   80104d00 <release>
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
8010388f:	e8 6c 14 00 00       	call   80104d00 <release>

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
801039b0:	e8 8b 12 00 00       	call   80104c40 <acquire>
  xticks = ticks;
801039b5:	8b 1d c0 ae 11 80    	mov    0x8011aec0,%ebx
  release(&tickslock);
801039bb:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
801039c2:	e8 39 13 00 00       	call   80104d00 <release>
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
80103b3a:	68 20 7e 10 80       	push   $0x80107e20
80103b3f:	68 40 82 11 80       	push   $0x80118240
80103b44:	e8 77 0f 00 00       	call   80104ac0 <initlock>
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
80103ba0:	68 27 7e 10 80       	push   $0x80107e27
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 18 7f 10 80       	push   $0x80107f18
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
80103beb:	e8 50 0f 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80103bf0:	e8 5b ff ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103bf5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bfb:	e8 90 0f 00 00       	call   80104b90 <popcli>
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
80103c27:	e8 24 3a 00 00       	call   80107650 <setupkvm>
80103c2c:	89 43 18             	mov    %eax,0x18(%ebx)
80103c2f:	85 c0                	test   %eax,%eax
80103c31:	0f 84 c1 00 00 00    	je     80103cf8 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c37:	83 ec 04             	sub    $0x4,%esp
80103c3a:	68 2c 00 00 00       	push   $0x2c
80103c3f:	68 60 b4 10 80       	push   $0x8010b460
80103c44:	50                   	push   %eax
80103c45:	e8 d6 36 00 00       	call   80107320 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c4a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c4d:	c7 43 14 00 10 00 00 	movl   $0x1000,0x14(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c54:	6a 4c                	push   $0x4c
80103c56:	6a 00                	push   $0x0
80103c58:	ff 73 2c             	pushl  0x2c(%ebx)
80103c5b:	e8 f0 10 00 00       	call   80104d50 <memset>
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
80103cb7:	68 50 7e 10 80       	push   $0x80107e50
80103cbc:	50                   	push   %eax
80103cbd:	e8 4e 12 00 00       	call   80104f10 <safestrcpy>
  p->cwd = namei("/");
80103cc2:	c7 04 24 59 7e 10 80 	movl   $0x80107e59,(%esp)
80103cc9:	e8 72 e3 ff ff       	call   80102040 <namei>
80103cce:	89 43 7c             	mov    %eax,0x7c(%ebx)
  acquire(&ptable.lock);
80103cd1:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103cd8:	e8 63 0f 00 00       	call   80104c40 <acquire>
  p->state = RUNNABLE;
80103cdd:	c7 43 20 03 00 00 00 	movl   $0x3,0x20(%ebx)
  release(&ptable.lock);
80103ce4:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103ceb:	e8 10 10 00 00       	call   80104d00 <release>
}
80103cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf3:	83 c4 10             	add    $0x10,%esp
80103cf6:	c9                   	leave  
80103cf7:	c3                   	ret    
    panic("userinit: out of memory?");
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	68 37 7e 10 80       	push   $0x80107e37
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
80103d1c:	e8 1f 0e 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80103d21:	e8 2a fe ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103d26:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d2c:	e8 5f 0e 00 00       	call   80104b90 <popcli>
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
80103d41:	e8 ca 34 00 00       	call   80107210 <switchuvm>
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
80103d62:	e8 09 37 00 00       	call   80107470 <allocuvm>
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
80103d82:	e8 19 38 00 00       	call   801075a0 <deallocuvm>
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
80103d9d:	e8 9e 0d 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80103da2:	e8 a9 fd ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103da7:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103dad:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  popcli();
80103db0:	e8 db 0d 00 00       	call   80104b90 <popcli>
  if((np = allocproc()) == 0){
80103db5:	e8 e6 f9 ff ff       	call   801037a0 <allocproc>
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	0f 84 07 01 00 00    	je     80103ec9 <fork+0x139>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dc2:	83 ec 08             	sub    $0x8,%esp
80103dc5:	ff 77 14             	pushl  0x14(%edi)
80103dc8:	89 c3                	mov    %eax,%ebx
80103dca:	ff 77 18             	pushl  0x18(%edi)
80103dcd:	e8 4e 39 00 00       	call   80107720 <copyuvm>
80103dd2:	83 c4 10             	add    $0x10,%esp
80103dd5:	89 43 18             	mov    %eax,0x18(%ebx)
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	0f 84 f0 00 00 00    	je     80103ed0 <fork+0x140>
  acquire(&tickslock);
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	68 80 a6 11 80       	push   $0x8011a680
80103de8:	e8 53 0e 00 00       	call   80104c40 <acquire>
  release(&tickslock);
80103ded:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
  xticks = ticks;
80103df4:	8b 35 c0 ae 11 80    	mov    0x8011aec0,%esi
  release(&tickslock);
80103dfa:	e8 01 0f 00 00       	call   80104d00 <release>
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
80103e8f:	e8 7c 10 00 00       	call   80104f10 <safestrcpy>
  pid = np->pid;
80103e94:	8b 73 24             	mov    0x24(%ebx),%esi
  acquire(&ptable.lock);
80103e97:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103e9e:	e8 9d 0d 00 00       	call   80104c40 <acquire>
  np->proc_index = np->pid;
80103ea3:	8b 43 24             	mov    0x24(%ebx),%eax
  np->state = RUNNABLE;
80103ea6:	c7 43 20 03 00 00 00 	movl   $0x3,0x20(%ebx)
  np->proc_index = np->pid;
80103ead:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&ptable.lock);
80103eb0:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
80103eb7:	e8 44 0e 00 00       	call   80104d00 <release>
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
80103f32:	e8 09 0d 00 00       	call   80104c40 <acquire>
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
80103fa7:	e8 64 32 00 00       	call   80107210 <switchuvm>
        p->state = RUNNING;
80103fac:	c7 47 90 04 00 00 00 	movl   $0x4,-0x70(%edi)
        swtch(&(c->scheduler), p->context);
80103fb3:	58                   	pop    %eax
80103fb4:	5a                   	pop    %edx
80103fb5:	ff 77 a0             	pushl  -0x60(%edi)
80103fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
80103fbb:	e8 b3 0f 00 00       	call   80104f73 <swtch>
        switchkvm();
80103fc0:	e8 2b 32 00 00       	call   801071f0 <switchkvm>
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
80104066:	e8 a5 31 00 00       	call   80107210 <switchuvm>
        p->state = RUNNING;
8010406b:	c7 47 90 04 00 00 00 	movl   $0x4,-0x70(%edi)
        swtch(&(c->scheduler), p->context);
80104072:	59                   	pop    %ecx
80104073:	5e                   	pop    %esi
80104074:	ff 77 a0             	pushl  -0x60(%edi)
80104077:	ff 75 e4             	pushl  -0x1c(%ebp)
8010407a:	e8 f4 0e 00 00       	call   80104f73 <swtch>
        switchkvm();
8010407f:	e8 6c 31 00 00       	call   801071f0 <switchkvm>
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
801040be:	e8 3d 0c 00 00       	call   80104d00 <release>
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
80104116:	e8 f5 30 00 00       	call   80107210 <switchuvm>
        p->state = RUNNING;
8010411b:	c7 47 20 04 00 00 00 	movl   $0x4,0x20(%edi)
        swtch(&(c->scheduler), p->context);
80104122:	58                   	pop    %eax
80104123:	5a                   	pop    %edx
80104124:	ff 77 30             	pushl  0x30(%edi)
80104127:	ff 75 e4             	pushl  -0x1c(%ebp)
8010412a:	e8 44 0e 00 00       	call   80104f73 <swtch>
        switchkvm();
8010412f:	e8 bc 30 00 00       	call   801071f0 <switchkvm>
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
80104159:	e8 e2 09 00 00       	call   80104b40 <pushcli>
  c = mycpu();
8010415e:	e8 ed f9 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104163:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104169:	e8 22 0a 00 00       	call   80104b90 <popcli>
  if(!holding(&ptable.lock))
8010416e:	83 ec 0c             	sub    $0xc,%esp
80104171:	68 40 82 11 80       	push   $0x80118240
80104176:	e8 75 0a 00 00       	call   80104bf0 <holding>
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
801041b7:	e8 b7 0d 00 00       	call   80104f73 <swtch>
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
801041d4:	68 5b 7e 10 80       	push   $0x80107e5b
801041d9:	e8 b2 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801041de:	83 ec 0c             	sub    $0xc,%esp
801041e1:	68 87 7e 10 80       	push   $0x80107e87
801041e6:	e8 a5 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	68 79 7e 10 80       	push   $0x80107e79
801041f3:	e8 98 c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 6d 7e 10 80       	push   $0x80107e6d
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
8010421d:	e8 1e 09 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80104222:	e8 29 f9 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104227:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010422d:	e8 5e 09 00 00       	call   80104b90 <popcli>
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
8010428a:	e8 b1 09 00 00       	call   80104c40 <acquire>
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
80104337:	68 a8 7e 10 80       	push   $0x80107ea8
8010433c:	e8 4f c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104341:	83 ec 0c             	sub    $0xc,%esp
80104344:	68 9b 7e 10 80       	push   $0x80107e9b
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
80104360:	e8 db 08 00 00       	call   80104c40 <acquire>
  pushcli();
80104365:	e8 d6 07 00 00       	call   80104b40 <pushcli>
  c = mycpu();
8010436a:	e8 e1 f7 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010436f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104375:	e8 16 08 00 00       	call   80104b90 <popcli>
  myproc()->state = RUNNABLE;
8010437a:	c7 43 20 03 00 00 00 	movl   $0x3,0x20(%ebx)
  sched();
80104381:	e8 ca fd ff ff       	call   80104150 <sched>
  release(&ptable.lock);
80104386:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
8010438d:	e8 6e 09 00 00       	call   80104d00 <release>
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
801043b3:	e8 88 07 00 00       	call   80104b40 <pushcli>
  c = mycpu();
801043b8:	e8 93 f7 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
801043bd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043c3:	e8 c8 07 00 00       	call   80104b90 <popcli>
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
801043e4:	e8 57 08 00 00       	call   80104c40 <acquire>
    release(lk);
801043e9:	89 34 24             	mov    %esi,(%esp)
801043ec:	e8 0f 09 00 00       	call   80104d00 <release>
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
8010440e:	e8 ed 08 00 00       	call   80104d00 <release>
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
80104420:	e9 1b 08 00 00       	jmp    80104c40 <acquire>
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
80104449:	68 ba 7e 10 80       	push   $0x80107eba
8010444e:	e8 3d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 b4 7e 10 80       	push   $0x80107eb4
8010445b:	e8 30 bf ff ff       	call   80100390 <panic>

80104460 <wait>:
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
80104465:	89 e5                	mov    %esp,%ebp
80104467:	56                   	push   %esi
80104468:	53                   	push   %ebx
  pushcli();
80104469:	e8 d2 06 00 00       	call   80104b40 <pushcli>
  c = mycpu();
8010446e:	e8 dd f6 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104473:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104479:	e8 12 07 00 00       	call   80104b90 <popcli>
  acquire(&ptable.lock);
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	68 40 82 11 80       	push   $0x80118240
80104486:	e8 b5 07 00 00       	call   80104c40 <acquire>
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
80104509:	e8 c2 30 00 00       	call   801075d0 <freevm>
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
8010453f:	e8 bc 07 00 00       	call   80104d00 <release>
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
8010455d:	e8 9e 07 00 00       	call   80104d00 <release>
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
80104583:	e8 b8 06 00 00       	call   80104c40 <acquire>
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
801045cd:	e9 2e 07 00 00       	jmp    80104d00 <release>
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
801045f3:	e8 48 06 00 00       	call   80104c40 <acquire>
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
80104635:	e8 c6 06 00 00       	call   80104d00 <release>
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
80104650:	e8 ab 06 00 00       	call   80104d00 <release>
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
80104693:	68 eb 7e 10 80       	push   $0x80107eeb
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
801046b9:	ba cb 7e 10 80       	mov    $0x80107ecb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046be:	83 f8 05             	cmp    $0x5,%eax
801046c1:	77 11                	ja     801046d4 <procdump+0x64>
801046c3:	8b 14 85 ec 7f 10 80 	mov    -0x7fef8014(,%eax,4),%edx
      state = "???";
801046ca:	b8 cb 7e 10 80       	mov    $0x80107ecb,%eax
801046cf:	85 d2                	test   %edx,%edx
801046d1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046d4:	53                   	push   %ebx
801046d5:	52                   	push   %edx
801046d6:	ff 73 a4             	pushl  -0x5c(%ebx)
801046d9:	68 cf 7e 10 80       	push   $0x80107ecf
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
80104700:	e8 db 03 00 00       	call   80104ae0 <getcallerpcs>
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
80104721:	68 21 79 10 80       	push   $0x80107921
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
80104766:	e8 d5 04 00 00       	call   80104c40 <acquire>
cprintf("name \t pid \t state \t\t priority  tickets  arrival \n");
8010476b:	c7 04 24 40 7f 10 80 	movl   $0x80107f40,(%esp)
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
801047c3:	68 74 7f 10 80       	push   $0x80107f74
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
801047e0:	e8 1b 05 00 00       	call   80104d00 <release>
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
80104806:	68 9c 7f 10 80       	push   $0x80107f9c
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
80104836:	68 c4 7f 10 80       	push   $0x80107fc4
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
80104869:	e8 d2 03 00 00       	call   80104c40 <acquire>
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
80104895:	68 d8 7e 10 80       	push   $0x80107ed8
8010489a:	e8 11 be ff ff       	call   801006b0 <cprintf>
  cprintf("%d  %d \n", p->pid, p->prio);
8010489f:	83 c4 0c             	add    $0xc,%esp
801048a2:	ff 73 10             	pushl  0x10(%ebx)
801048a5:	ff 73 24             	pushl  0x24(%ebx)
801048a8:	68 e4 7e 10 80       	push   $0x80107ee4
801048ad:	e8 fe bd ff ff       	call   801006b0 <cprintf>
	release(&ptable.lock);
801048b2:	c7 04 24 40 82 11 80 	movl   $0x80118240,(%esp)
801048b9:	e8 42 04 00 00       	call   80104d00 <release>
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
801048e3:	e8 58 03 00 00       	call   80104c40 <acquire>
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
8010491b:	e9 e0 03 00 00       	jmp    80104d00 <release>

80104920 <proc_ticket>:

int proc_ticket(int pid, int ticket) {
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	53                   	push   %ebx
80104928:	83 ec 10             	sub    $0x10,%esp
8010492b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;
    acquire(&ptable.lock);
8010492e:	68 40 82 11 80       	push   $0x80118240
80104933:	e8 08 03 00 00       	call   80104c40 <acquire>
80104938:	83 c4 10             	add    $0x10,%esp

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493b:	b8 74 82 11 80       	mov    $0x80118274,%eax
80104940:	eb 12                	jmp    80104954 <proc_ticket+0x34>
80104942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104948:	05 90 00 00 00       	add    $0x90,%eax
8010494d:	3d 74 a6 11 80       	cmp    $0x8011a674,%eax
80104952:	74 0b                	je     8010495f <proc_ticket+0x3f>
      if(p->pid == pid){
80104954:	39 58 24             	cmp    %ebx,0x24(%eax)
80104957:	75 ef                	jne    80104948 <proc_ticket+0x28>
        p->tickets = ticket;
80104959:	8b 55 0c             	mov    0xc(%ebp),%edx
8010495c:	89 50 08             	mov    %edx,0x8(%eax)
        break;
      }
    }

    release(&ptable.lock);
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	68 40 82 11 80       	push   $0x80118240
80104967:	e8 94 03 00 00       	call   80104d00 <release>
    return 0;
8010496c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010496f:	31 c0                	xor    %eax,%eax
80104971:	c9                   	leave  
80104972:	c3                   	ret    
80104973:	66 90                	xchg   %ax,%ax
80104975:	66 90                	xchg   %ax,%ax
80104977:	66 90                	xchg   %ax,%ax
80104979:	66 90                	xchg   %ax,%ax
8010497b:	66 90                	xchg   %ax,%ax
8010497d:	66 90                	xchg   %ax,%ax
8010497f:	90                   	nop

80104980 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	53                   	push   %ebx
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010498e:	68 04 80 10 80       	push   $0x80108004
80104993:	8d 43 04             	lea    0x4(%ebx),%eax
80104996:	50                   	push   %eax
80104997:	e8 24 01 00 00       	call   80104ac0 <initlock>
  lk->name = name;
8010499c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010499f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049a5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049a8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049af:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b5:	c9                   	leave  
801049b6:	c3                   	ret    
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
801049d3:	e8 68 02 00 00       	call   80104c40 <acquire>
  while (lk->locked) {
801049d8:	8b 13                	mov    (%ebx),%edx
801049da:	83 c4 10             	add    $0x10,%esp
801049dd:	85 d2                	test   %edx,%edx
801049df:	74 1a                	je     801049fb <acquiresleep+0x3b>
801049e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801049e8:	83 ec 08             	sub    $0x8,%esp
801049eb:	56                   	push   %esi
801049ec:	53                   	push   %ebx
801049ed:	e8 ae f9 ff ff       	call   801043a0 <sleep>
  while (lk->locked) {
801049f2:	8b 03                	mov    (%ebx),%eax
801049f4:	83 c4 10             	add    $0x10,%esp
801049f7:	85 c0                	test   %eax,%eax
801049f9:	75 ed                	jne    801049e8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801049fb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a01:	e8 da f1 ff ff       	call   80103be0 <myproc>
80104a06:	8b 40 24             	mov    0x24(%eax),%eax
80104a09:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a0c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
  release(&lk->lk);
80104a15:	e9 e6 02 00 00       	jmp    80104d00 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	56                   	push   %esi
80104a28:	53                   	push   %ebx
80104a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a2f:	83 ec 0c             	sub    $0xc,%esp
80104a32:	56                   	push   %esi
80104a33:	e8 08 02 00 00       	call   80104c40 <acquire>
  lk->locked = 0;
80104a38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a3e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a45:	89 1c 24             	mov    %ebx,(%esp)
80104a48:	e8 23 fb ff ff       	call   80104570 <wakeup>
  release(&lk->lk);
80104a4d:	89 75 08             	mov    %esi,0x8(%ebp)
80104a50:	83 c4 10             	add    $0x10,%esp
}
80104a53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a56:	5b                   	pop    %ebx
80104a57:	5e                   	pop    %esi
80104a58:	5d                   	pop    %ebp
  release(&lk->lk);
80104a59:	e9 a2 02 00 00       	jmp    80104d00 <release>
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	57                   	push   %edi
80104a68:	31 ff                	xor    %edi,%edi
80104a6a:	56                   	push   %esi
80104a6b:	53                   	push   %ebx
80104a6c:	83 ec 18             	sub    $0x18,%esp
80104a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a72:	8d 73 04             	lea    0x4(%ebx),%esi
80104a75:	56                   	push   %esi
80104a76:	e8 c5 01 00 00       	call   80104c40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a7b:	8b 03                	mov    (%ebx),%eax
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	85 c0                	test   %eax,%eax
80104a82:	75 1c                	jne    80104aa0 <holdingsleep+0x40>
  release(&lk->lk);
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	56                   	push   %esi
80104a88:	e8 73 02 00 00       	call   80104d00 <release>
  return r;
}
80104a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a90:	89 f8                	mov    %edi,%eax
80104a92:	5b                   	pop    %ebx
80104a93:	5e                   	pop    %esi
80104a94:	5f                   	pop    %edi
80104a95:	5d                   	pop    %ebp
80104a96:	c3                   	ret    
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104aa0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104aa3:	e8 38 f1 ff ff       	call   80103be0 <myproc>
80104aa8:	39 58 24             	cmp    %ebx,0x24(%eax)
80104aab:	0f 94 c0             	sete   %al
80104aae:	0f b6 c0             	movzbl %al,%eax
80104ab1:	89 c7                	mov    %eax,%edi
80104ab3:	eb cf                	jmp    80104a84 <holdingsleep+0x24>
80104ab5:	66 90                	xchg   %ax,%ax
80104ab7:	66 90                	xchg   %ax,%ax
80104ab9:	66 90                	xchg   %ax,%ax
80104abb:	66 90                	xchg   %ax,%ax
80104abd:	66 90                	xchg   %ax,%ax
80104abf:	90                   	nop

80104ac0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ad3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ad6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104add:	5d                   	pop    %ebp
80104ade:	c3                   	ret    
80104adf:	90                   	nop

80104ae0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ae5:	31 d2                	xor    %edx,%edx
{
80104ae7:	89 e5                	mov    %esp,%ebp
80104ae9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104aea:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104af0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104af3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104af7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104afe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b04:	77 1a                	ja     80104b20 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b06:	8b 58 04             	mov    0x4(%eax),%ebx
80104b09:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b0c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b11:	83 fa 0a             	cmp    $0xa,%edx
80104b14:	75 e2                	jne    80104af8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b16:	5b                   	pop    %ebx
80104b17:	5d                   	pop    %ebp
80104b18:	c3                   	ret    
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b23:	8d 51 28             	lea    0x28(%ecx),%edx
80104b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b36:	83 c0 04             	add    $0x4,%eax
80104b39:	39 d0                	cmp    %edx,%eax
80104b3b:	75 f3                	jne    80104b30 <getcallerpcs+0x50>
}
80104b3d:	5b                   	pop    %ebx
80104b3e:	5d                   	pop    %ebp
80104b3f:	c3                   	ret    

80104b40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	53                   	push   %ebx
80104b48:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b4b:	9c                   	pushf  
80104b4c:	5b                   	pop    %ebx
  asm volatile("cli");
80104b4d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b4e:	e8 fd ef ff ff       	call   80103b50 <mycpu>
80104b53:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	74 13                	je     80104b70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b5d:	e8 ee ef ff ff       	call   80103b50 <mycpu>
80104b62:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b69:	83 c4 04             	add    $0x4,%esp
80104b6c:	5b                   	pop    %ebx
80104b6d:	5d                   	pop    %ebp
80104b6e:	c3                   	ret    
80104b6f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104b70:	e8 db ef ff ff       	call   80103b50 <mycpu>
80104b75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b81:	eb da                	jmp    80104b5d <pushcli+0x1d>
80104b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <popcli>:

void
popcli(void)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b9a:	9c                   	pushf  
80104b9b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b9c:	f6 c4 02             	test   $0x2,%ah
80104b9f:	75 31                	jne    80104bd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ba1:	e8 aa ef ff ff       	call   80103b50 <mycpu>
80104ba6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bad:	78 30                	js     80104bdf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104baf:	e8 9c ef ff ff       	call   80103b50 <mycpu>
80104bb4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104bba:	85 d2                	test   %edx,%edx
80104bbc:	74 02                	je     80104bc0 <popcli+0x30>
    sti();
}
80104bbe:	c9                   	leave  
80104bbf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bc0:	e8 8b ef ff ff       	call   80103b50 <mycpu>
80104bc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bcb:	85 c0                	test   %eax,%eax
80104bcd:	74 ef                	je     80104bbe <popcli+0x2e>
  asm volatile("sti");
80104bcf:	fb                   	sti    
}
80104bd0:	c9                   	leave  
80104bd1:	c3                   	ret    
    panic("popcli - interruptible");
80104bd2:	83 ec 0c             	sub    $0xc,%esp
80104bd5:	68 0f 80 10 80       	push   $0x8010800f
80104bda:	e8 b1 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104bdf:	83 ec 0c             	sub    $0xc,%esp
80104be2:	68 26 80 10 80       	push   $0x80108026
80104be7:	e8 a4 b7 ff ff       	call   80100390 <panic>
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <holding>:
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	56                   	push   %esi
80104bf8:	53                   	push   %ebx
80104bf9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bfc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bfe:	e8 3d ff ff ff       	call   80104b40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c03:	8b 06                	mov    (%esi),%eax
80104c05:	85 c0                	test   %eax,%eax
80104c07:	75 0f                	jne    80104c18 <holding+0x28>
  popcli();
80104c09:	e8 82 ff ff ff       	call   80104b90 <popcli>
}
80104c0e:	89 d8                	mov    %ebx,%eax
80104c10:	5b                   	pop    %ebx
80104c11:	5e                   	pop    %esi
80104c12:	5d                   	pop    %ebp
80104c13:	c3                   	ret    
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c18:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c1b:	e8 30 ef ff ff       	call   80103b50 <mycpu>
80104c20:	39 c3                	cmp    %eax,%ebx
80104c22:	0f 94 c3             	sete   %bl
  popcli();
80104c25:	e8 66 ff ff ff       	call   80104b90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104c2a:	0f b6 db             	movzbl %bl,%ebx
}
80104c2d:	89 d8                	mov    %ebx,%eax
80104c2f:	5b                   	pop    %ebx
80104c30:	5e                   	pop    %esi
80104c31:	5d                   	pop    %ebp
80104c32:	c3                   	ret    
80104c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c40 <acquire>:
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	56                   	push   %esi
80104c48:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c49:	e8 f2 fe ff ff       	call   80104b40 <pushcli>
  if(holding(lk))
80104c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c51:	83 ec 0c             	sub    $0xc,%esp
80104c54:	53                   	push   %ebx
80104c55:	e8 96 ff ff ff       	call   80104bf0 <holding>
80104c5a:	83 c4 10             	add    $0x10,%esp
80104c5d:	85 c0                	test   %eax,%eax
80104c5f:	0f 85 7f 00 00 00    	jne    80104ce4 <acquire+0xa4>
80104c65:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c67:	ba 01 00 00 00       	mov    $0x1,%edx
80104c6c:	eb 05                	jmp    80104c73 <acquire+0x33>
80104c6e:	66 90                	xchg   %ax,%ax
80104c70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c73:	89 d0                	mov    %edx,%eax
80104c75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c78:	85 c0                	test   %eax,%eax
80104c7a:	75 f4                	jne    80104c70 <acquire+0x30>
  __sync_synchronize();
80104c7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c84:	e8 c7 ee ff ff       	call   80103b50 <mycpu>
80104c89:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c8c:	89 e8                	mov    %ebp,%eax
80104c8e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c90:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104c96:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104c9c:	77 22                	ja     80104cc0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c9e:	8b 50 04             	mov    0x4(%eax),%edx
80104ca1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104ca5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ca8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104caa:	83 fe 0a             	cmp    $0xa,%esi
80104cad:	75 e1                	jne    80104c90 <acquire+0x50>
}
80104caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb2:	5b                   	pop    %ebx
80104cb3:	5e                   	pop    %esi
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret    
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104cc0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104cc4:	83 c3 34             	add    $0x34,%ebx
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cd6:	83 c0 04             	add    $0x4,%eax
80104cd9:	39 d8                	cmp    %ebx,%eax
80104cdb:	75 f3                	jne    80104cd0 <acquire+0x90>
}
80104cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce0:	5b                   	pop    %ebx
80104ce1:	5e                   	pop    %esi
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    
    panic("acquire");
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	68 2d 80 10 80       	push   $0x8010802d
80104cec:	e8 9f b6 ff ff       	call   80100390 <panic>
80104cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop

80104d00 <release>:
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	53                   	push   %ebx
80104d08:	83 ec 10             	sub    $0x10,%esp
80104d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d0e:	53                   	push   %ebx
80104d0f:	e8 dc fe ff ff       	call   80104bf0 <holding>
80104d14:	83 c4 10             	add    $0x10,%esp
80104d17:	85 c0                	test   %eax,%eax
80104d19:	74 22                	je     80104d3d <release+0x3d>
  lk->pcs[0] = 0;
80104d1b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d29:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d37:	c9                   	leave  
  popcli();
80104d38:	e9 53 fe ff ff       	jmp    80104b90 <popcli>
    panic("release");
80104d3d:	83 ec 0c             	sub    $0xc,%esp
80104d40:	68 35 80 10 80       	push   $0x80108035
80104d45:	e8 46 b6 ff ff       	call   80100390 <panic>
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	57                   	push   %edi
80104d58:	8b 55 08             	mov    0x8(%ebp),%edx
80104d5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d5e:	53                   	push   %ebx
80104d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104d62:	89 d7                	mov    %edx,%edi
80104d64:	09 cf                	or     %ecx,%edi
80104d66:	83 e7 03             	and    $0x3,%edi
80104d69:	75 25                	jne    80104d90 <memset+0x40>
    c &= 0xFF;
80104d6b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d6e:	c1 e0 18             	shl    $0x18,%eax
80104d71:	89 fb                	mov    %edi,%ebx
80104d73:	c1 e9 02             	shr    $0x2,%ecx
80104d76:	c1 e3 10             	shl    $0x10,%ebx
80104d79:	09 d8                	or     %ebx,%eax
80104d7b:	09 f8                	or     %edi,%eax
80104d7d:	c1 e7 08             	shl    $0x8,%edi
80104d80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d82:	89 d7                	mov    %edx,%edi
80104d84:	fc                   	cld    
80104d85:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d87:	5b                   	pop    %ebx
80104d88:	89 d0                	mov    %edx,%eax
80104d8a:	5f                   	pop    %edi
80104d8b:	5d                   	pop    %ebp
80104d8c:	c3                   	ret    
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104d90:	89 d7                	mov    %edx,%edi
80104d92:	fc                   	cld    
80104d93:	f3 aa                	rep stos %al,%es:(%edi)
80104d95:	5b                   	pop    %ebx
80104d96:	89 d0                	mov    %edx,%eax
80104d98:	5f                   	pop    %edi
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop

80104da0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	56                   	push   %esi
80104da8:	8b 75 10             	mov    0x10(%ebp),%esi
80104dab:	8b 55 08             	mov    0x8(%ebp),%edx
80104dae:	53                   	push   %ebx
80104daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104db2:	85 f6                	test   %esi,%esi
80104db4:	74 2a                	je     80104de0 <memcmp+0x40>
80104db6:	01 c6                	add    %eax,%esi
80104db8:	eb 10                	jmp    80104dca <memcmp+0x2a>
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104dc0:	83 c0 01             	add    $0x1,%eax
80104dc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104dc6:	39 f0                	cmp    %esi,%eax
80104dc8:	74 16                	je     80104de0 <memcmp+0x40>
    if(*s1 != *s2)
80104dca:	0f b6 0a             	movzbl (%edx),%ecx
80104dcd:	0f b6 18             	movzbl (%eax),%ebx
80104dd0:	38 d9                	cmp    %bl,%cl
80104dd2:	74 ec                	je     80104dc0 <memcmp+0x20>
      return *s1 - *s2;
80104dd4:	0f b6 c1             	movzbl %cl,%eax
80104dd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104dd9:	5b                   	pop    %ebx
80104dda:	5e                   	pop    %esi
80104ddb:	5d                   	pop    %ebp
80104ddc:	c3                   	ret    
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
80104de0:	5b                   	pop    %ebx
  return 0;
80104de1:	31 c0                	xor    %eax,%eax
}
80104de3:	5e                   	pop    %esi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi

80104df0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	57                   	push   %edi
80104df8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dfe:	56                   	push   %esi
80104dff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e02:	39 d6                	cmp    %edx,%esi
80104e04:	73 2a                	jae    80104e30 <memmove+0x40>
80104e06:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e09:	39 fa                	cmp    %edi,%edx
80104e0b:	73 23                	jae    80104e30 <memmove+0x40>
80104e0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104e10:	85 c9                	test   %ecx,%ecx
80104e12:	74 13                	je     80104e27 <memmove+0x37>
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104e18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e1c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e1f:	83 e8 01             	sub    $0x1,%eax
80104e22:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e25:	75 f1                	jne    80104e18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e27:	5e                   	pop    %esi
80104e28:	89 d0                	mov    %edx,%eax
80104e2a:	5f                   	pop    %edi
80104e2b:	5d                   	pop    %ebp
80104e2c:	c3                   	ret    
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e30:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e33:	89 d7                	mov    %edx,%edi
80104e35:	85 c9                	test   %ecx,%ecx
80104e37:	74 ee                	je     80104e27 <memmove+0x37>
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e41:	39 f0                	cmp    %esi,%eax
80104e43:	75 fb                	jne    80104e40 <memmove+0x50>
}
80104e45:	5e                   	pop    %esi
80104e46:	89 d0                	mov    %edx,%eax
80104e48:	5f                   	pop    %edi
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop

80104e50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e50:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104e54:	eb 9a                	jmp    80104df0 <memmove>
80104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi

80104e60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	56                   	push   %esi
80104e68:	8b 75 10             	mov    0x10(%ebp),%esi
80104e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e6e:	53                   	push   %ebx
80104e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104e72:	85 f6                	test   %esi,%esi
80104e74:	74 32                	je     80104ea8 <strncmp+0x48>
80104e76:	01 c6                	add    %eax,%esi
80104e78:	eb 14                	jmp    80104e8e <strncmp+0x2e>
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e80:	38 da                	cmp    %bl,%dl
80104e82:	75 14                	jne    80104e98 <strncmp+0x38>
    n--, p++, q++;
80104e84:	83 c0 01             	add    $0x1,%eax
80104e87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e8a:	39 f0                	cmp    %esi,%eax
80104e8c:	74 1a                	je     80104ea8 <strncmp+0x48>
80104e8e:	0f b6 11             	movzbl (%ecx),%edx
80104e91:	0f b6 18             	movzbl (%eax),%ebx
80104e94:	84 d2                	test   %dl,%dl
80104e96:	75 e8                	jne    80104e80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e98:	0f b6 c2             	movzbl %dl,%eax
80104e9b:	29 d8                	sub    %ebx,%eax
}
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5d                   	pop    %ebp
80104ea0:	c3                   	ret    
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	5b                   	pop    %ebx
    return 0;
80104ea9:	31 c0                	xor    %eax,%eax
}
80104eab:	5e                   	pop    %esi
80104eac:	5d                   	pop    %ebp
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	57                   	push   %edi
80104eb8:	56                   	push   %esi
80104eb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ebc:	53                   	push   %ebx
80104ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ec0:	89 f2                	mov    %esi,%edx
80104ec2:	eb 1b                	jmp    80104edf <strncpy+0x2f>
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ecc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ecf:	83 c2 01             	add    $0x1,%edx
80104ed2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104ed6:	89 f9                	mov    %edi,%ecx
80104ed8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104edb:	84 c9                	test   %cl,%cl
80104edd:	74 09                	je     80104ee8 <strncpy+0x38>
80104edf:	89 c3                	mov    %eax,%ebx
80104ee1:	83 e8 01             	sub    $0x1,%eax
80104ee4:	85 db                	test   %ebx,%ebx
80104ee6:	7f e0                	jg     80104ec8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ee8:	89 d1                	mov    %edx,%ecx
80104eea:	85 c0                	test   %eax,%eax
80104eec:	7e 15                	jle    80104f03 <strncpy+0x53>
80104eee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104ef0:	83 c1 01             	add    $0x1,%ecx
80104ef3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ef7:	89 c8                	mov    %ecx,%eax
80104ef9:	f7 d0                	not    %eax
80104efb:	01 d0                	add    %edx,%eax
80104efd:	01 d8                	add    %ebx,%eax
80104eff:	85 c0                	test   %eax,%eax
80104f01:	7f ed                	jg     80104ef0 <strncpy+0x40>
  return os;
}
80104f03:	5b                   	pop    %ebx
80104f04:	89 f0                	mov    %esi,%eax
80104f06:	5e                   	pop    %esi
80104f07:	5f                   	pop    %edi
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	56                   	push   %esi
80104f18:	8b 55 10             	mov    0x10(%ebp),%edx
80104f1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104f1e:	53                   	push   %ebx
80104f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f22:	85 d2                	test   %edx,%edx
80104f24:	7e 21                	jle    80104f47 <safestrcpy+0x37>
80104f26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f2a:	89 f2                	mov    %esi,%edx
80104f2c:	eb 12                	jmp    80104f40 <safestrcpy+0x30>
80104f2e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f30:	0f b6 08             	movzbl (%eax),%ecx
80104f33:	83 c0 01             	add    $0x1,%eax
80104f36:	83 c2 01             	add    $0x1,%edx
80104f39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f3c:	84 c9                	test   %cl,%cl
80104f3e:	74 04                	je     80104f44 <safestrcpy+0x34>
80104f40:	39 d8                	cmp    %ebx,%eax
80104f42:	75 ec                	jne    80104f30 <safestrcpy+0x20>
    ;
  *s = 0;
80104f44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f47:	89 f0                	mov    %esi,%eax
80104f49:	5b                   	pop    %ebx
80104f4a:	5e                   	pop    %esi
80104f4b:	5d                   	pop    %ebp
80104f4c:	c3                   	ret    
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <strlen>:

int
strlen(const char *s)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f55:	31 c0                	xor    %eax,%eax
{
80104f57:	89 e5                	mov    %esp,%ebp
80104f59:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f5c:	80 3a 00             	cmpb   $0x0,(%edx)
80104f5f:	74 10                	je     80104f71 <strlen+0x21>
80104f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f68:	83 c0 01             	add    $0x1,%eax
80104f6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f6f:	75 f7                	jne    80104f68 <strlen+0x18>
    ;
  return n;
}
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret    

80104f73 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f7b:	55                   	push   %ebp
  pushl %ebx
80104f7c:	53                   	push   %ebx
  pushl %esi
80104f7d:	56                   	push   %esi
  pushl %edi
80104f7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f81:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f83:	5f                   	pop    %edi
  popl %esi
80104f84:	5e                   	pop    %esi
  popl %ebx
80104f85:	5b                   	pop    %ebx
  popl %ebp
80104f86:	5d                   	pop    %ebp
  ret
80104f87:	c3                   	ret    
80104f88:	66 90                	xchg   %ax,%ax
80104f8a:	66 90                	xchg   %ax,%ax
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	53                   	push   %ebx
80104f98:	83 ec 04             	sub    $0x4,%esp
80104f9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f9e:	e8 3d ec ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fa3:	8b 40 14             	mov    0x14(%eax),%eax
80104fa6:	39 d8                	cmp    %ebx,%eax
80104fa8:	76 16                	jbe    80104fc0 <fetchint+0x30>
80104faa:	8d 53 04             	lea    0x4(%ebx),%edx
80104fad:	39 d0                	cmp    %edx,%eax
80104faf:	72 0f                	jb     80104fc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fb4:	8b 13                	mov    (%ebx),%edx
80104fb6:	89 10                	mov    %edx,(%eax)
  return 0;
80104fb8:	31 c0                	xor    %eax,%eax
}
80104fba:	83 c4 04             	add    $0x4,%esp
80104fbd:	5b                   	pop    %ebx
80104fbe:	5d                   	pop    %ebp
80104fbf:	c3                   	ret    
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb f3                	jmp    80104fba <fetchint+0x2a>
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	53                   	push   %ebx
80104fd8:	83 ec 04             	sub    $0x4,%esp
80104fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104fde:	e8 fd eb ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz)
80104fe3:	39 58 14             	cmp    %ebx,0x14(%eax)
80104fe6:	76 30                	jbe    80105018 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104feb:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104fed:	8b 50 14             	mov    0x14(%eax),%edx
  for(s = *pp; s < ep; s++){
80104ff0:	39 d3                	cmp    %edx,%ebx
80104ff2:	73 24                	jae    80105018 <fetchstr+0x48>
80104ff4:	89 d8                	mov    %ebx,%eax
80104ff6:	eb 0f                	jmp    80105007 <fetchstr+0x37>
80104ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop
80105000:	83 c0 01             	add    $0x1,%eax
80105003:	39 c2                	cmp    %eax,%edx
80105005:	76 11                	jbe    80105018 <fetchstr+0x48>
    if(*s == 0)
80105007:	80 38 00             	cmpb   $0x0,(%eax)
8010500a:	75 f4                	jne    80105000 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010500c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010500f:	29 d8                	sub    %ebx,%eax
}
80105011:	5b                   	pop    %ebx
80105012:	5d                   	pop    %ebp
80105013:	c3                   	ret    
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	83 c4 04             	add    $0x4,%esp
    return -1;
8010501b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105020:	5b                   	pop    %ebx
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105030 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	56                   	push   %esi
80105038:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105039:	e8 a2 eb ff ff       	call   80103be0 <myproc>
8010503e:	8b 55 08             	mov    0x8(%ebp),%edx
80105041:	8b 40 2c             	mov    0x2c(%eax),%eax
80105044:	8b 40 44             	mov    0x44(%eax),%eax
80105047:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010504a:	e8 91 eb ff ff       	call   80103be0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010504f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105052:	8b 40 14             	mov    0x14(%eax),%eax
80105055:	39 c6                	cmp    %eax,%esi
80105057:	73 17                	jae    80105070 <argint+0x40>
80105059:	8d 53 08             	lea    0x8(%ebx),%edx
8010505c:	39 d0                	cmp    %edx,%eax
8010505e:	72 10                	jb     80105070 <argint+0x40>
  *ip = *(int*)(addr);
80105060:	8b 45 0c             	mov    0xc(%ebp),%eax
80105063:	8b 53 04             	mov    0x4(%ebx),%edx
80105066:	89 10                	mov    %edx,(%eax)
  return 0;
80105068:	31 c0                	xor    %eax,%eax
}
8010506a:	5b                   	pop    %ebx
8010506b:	5e                   	pop    %esi
8010506c:	5d                   	pop    %ebp
8010506d:	c3                   	ret    
8010506e:	66 90                	xchg   %ax,%ax
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105075:	eb f3                	jmp    8010506a <argint+0x3a>
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax

80105080 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	56                   	push   %esi
80105088:	53                   	push   %ebx
80105089:	83 ec 10             	sub    $0x10,%esp
8010508c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010508f:	e8 4c eb ff ff       	call   80103be0 <myproc>
 
  if(argint(n, &i) < 0)
80105094:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105097:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105099:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010509c:	50                   	push   %eax
8010509d:	ff 75 08             	pushl  0x8(%ebp)
801050a0:	e8 8b ff ff ff       	call   80105030 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	85 c0                	test   %eax,%eax
801050aa:	78 24                	js     801050d0 <argptr+0x50>
801050ac:	85 db                	test   %ebx,%ebx
801050ae:	78 20                	js     801050d0 <argptr+0x50>
801050b0:	8b 56 14             	mov    0x14(%esi),%edx
801050b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b6:	39 c2                	cmp    %eax,%edx
801050b8:	76 16                	jbe    801050d0 <argptr+0x50>
801050ba:	01 c3                	add    %eax,%ebx
801050bc:	39 da                	cmp    %ebx,%edx
801050be:	72 10                	jb     801050d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801050c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801050c3:	89 02                	mov    %eax,(%edx)
  return 0;
801050c5:	31 c0                	xor    %eax,%eax
}
801050c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ca:	5b                   	pop    %ebx
801050cb:	5e                   	pop    %esi
801050cc:	5d                   	pop    %ebp
801050cd:	c3                   	ret    
801050ce:	66 90                	xchg   %ax,%ax
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d5:	eb f0                	jmp    801050c7 <argptr+0x47>
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ed:	50                   	push   %eax
801050ee:	ff 75 08             	pushl  0x8(%ebp)
801050f1:	e8 3a ff ff ff       	call   80105030 <argint>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	78 13                	js     80105110 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050fd:	83 ec 08             	sub    $0x8,%esp
80105100:	ff 75 0c             	pushl  0xc(%ebp)
80105103:	ff 75 f4             	pushl  -0xc(%ebp)
80105106:	e8 c5 fe ff ff       	call   80104fd0 <fetchstr>
8010510b:	83 c4 10             	add    $0x10,%esp
}
8010510e:	c9                   	leave  
8010510f:	c3                   	ret    
80105110:	c9                   	leave  
    return -1;
80105111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105116:	c3                   	ret    
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <syscall>:
[SYS_changeTicket] sys_changeTicket,
};

void
syscall(void)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	53                   	push   %ebx
80105128:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010512b:	e8 b0 ea ff ff       	call   80103be0 <myproc>
80105130:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105132:	8b 40 2c             	mov    0x2c(%eax),%eax
80105135:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105138:	8d 50 ff             	lea    -0x1(%eax),%edx
8010513b:	83 fa 19             	cmp    $0x19,%edx
8010513e:	77 20                	ja     80105160 <syscall+0x40>
80105140:	8b 14 85 60 80 10 80 	mov    -0x7fef7fa0(,%eax,4),%edx
80105147:	85 d2                	test   %edx,%edx
80105149:	74 15                	je     80105160 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010514b:	ff d2                	call   *%edx
8010514d:	89 c2                	mov    %eax,%edx
8010514f:	8b 43 2c             	mov    0x2c(%ebx),%eax
80105152:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105158:	c9                   	leave  
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105160:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105161:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105167:	50                   	push   %eax
80105168:	ff 73 24             	pushl  0x24(%ebx)
8010516b:	68 3d 80 10 80       	push   $0x8010803d
80105170:	e8 3b b5 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105175:	8b 43 2c             	mov    0x2c(%ebx),%eax
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	66 90                	xchg   %ax,%ax
80105189:	66 90                	xchg   %ax,%ax
8010518b:	66 90                	xchg   %ax,%ax
8010518d:	66 90                	xchg   %ax,%ax
8010518f:	90                   	nop

80105190 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105195:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105198:	53                   	push   %ebx
80105199:	83 ec 34             	sub    $0x34,%esp
8010519c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010519f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801051a2:	57                   	push   %edi
801051a3:	50                   	push   %eax
{
801051a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051aa:	e8 b1 ce ff ff       	call   80102060 <nameiparent>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	0f 84 46 01 00 00    	je     80105300 <create+0x170>
    return 0;
  ilock(dp);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	89 c3                	mov    %eax,%ebx
801051bf:	50                   	push   %eax
801051c0:	e8 ab c5 ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051c5:	83 c4 0c             	add    $0xc,%esp
801051c8:	6a 00                	push   $0x0
801051ca:	57                   	push   %edi
801051cb:	53                   	push   %ebx
801051cc:	e8 ef ca ff ff       	call   80101cc0 <dirlookup>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	89 c6                	mov    %eax,%esi
801051d6:	85 c0                	test   %eax,%eax
801051d8:	74 56                	je     80105230 <create+0xa0>
    iunlockput(dp);
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	53                   	push   %ebx
801051de:	e8 2d c8 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801051e3:	89 34 24             	mov    %esi,(%esp)
801051e6:	e8 85 c5 ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051eb:	83 c4 10             	add    $0x10,%esp
801051ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051f3:	75 1b                	jne    80105210 <create+0x80>
801051f5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801051fa:	75 14                	jne    80105210 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ff:	89 f0                	mov    %esi,%eax
80105201:	5b                   	pop    %ebx
80105202:	5e                   	pop    %esi
80105203:	5f                   	pop    %edi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	56                   	push   %esi
    return 0;
80105214:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105216:	e8 f5 c7 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010521b:	83 c4 10             	add    $0x10,%esp
}
8010521e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105221:	89 f0                	mov    %esi,%eax
80105223:	5b                   	pop    %ebx
80105224:	5e                   	pop    %esi
80105225:	5f                   	pop    %edi
80105226:	5d                   	pop    %ebp
80105227:	c3                   	ret    
80105228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105230:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105234:	83 ec 08             	sub    $0x8,%esp
80105237:	50                   	push   %eax
80105238:	ff 33                	pushl  (%ebx)
8010523a:	e8 b1 c3 ff ff       	call   801015f0 <ialloc>
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	89 c6                	mov    %eax,%esi
80105244:	85 c0                	test   %eax,%eax
80105246:	0f 84 cd 00 00 00    	je     80105319 <create+0x189>
  ilock(ip);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	50                   	push   %eax
80105250:	e8 1b c5 ff ff       	call   80101770 <ilock>
  ip->major = major;
80105255:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105259:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010525d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105261:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105265:	b8 01 00 00 00       	mov    $0x1,%eax
8010526a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010526e:	89 34 24             	mov    %esi,(%esp)
80105271:	e8 3a c4 ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010527e:	74 30                	je     801052b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105280:	83 ec 04             	sub    $0x4,%esp
80105283:	ff 76 04             	pushl  0x4(%esi)
80105286:	57                   	push   %edi
80105287:	53                   	push   %ebx
80105288:	e8 f3 cc ff ff       	call   80101f80 <dirlink>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 78                	js     8010530c <create+0x17c>
  iunlockput(dp);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	53                   	push   %ebx
80105298:	e8 73 c7 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010529d:	83 c4 10             	add    $0x10,%esp
}
801052a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a3:	89 f0                	mov    %esi,%eax
801052a5:	5b                   	pop    %ebx
801052a6:	5e                   	pop    %esi
801052a7:	5f                   	pop    %edi
801052a8:	5d                   	pop    %ebp
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801052b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052b8:	53                   	push   %ebx
801052b9:	e8 f2 c3 ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052be:	83 c4 0c             	add    $0xc,%esp
801052c1:	ff 76 04             	pushl  0x4(%esi)
801052c4:	68 e8 80 10 80       	push   $0x801080e8
801052c9:	56                   	push   %esi
801052ca:	e8 b1 cc ff ff       	call   80101f80 <dirlink>
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	85 c0                	test   %eax,%eax
801052d4:	78 18                	js     801052ee <create+0x15e>
801052d6:	83 ec 04             	sub    $0x4,%esp
801052d9:	ff 73 04             	pushl  0x4(%ebx)
801052dc:	68 e7 80 10 80       	push   $0x801080e7
801052e1:	56                   	push   %esi
801052e2:	e8 99 cc ff ff       	call   80101f80 <dirlink>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	85 c0                	test   %eax,%eax
801052ec:	79 92                	jns    80105280 <create+0xf0>
      panic("create dots");
801052ee:	83 ec 0c             	sub    $0xc,%esp
801052f1:	68 db 80 10 80       	push   $0x801080db
801052f6:	e8 95 b0 ff ff       	call   80100390 <panic>
801052fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop
}
80105300:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105303:	31 f6                	xor    %esi,%esi
}
80105305:	5b                   	pop    %ebx
80105306:	89 f0                	mov    %esi,%eax
80105308:	5e                   	pop    %esi
80105309:	5f                   	pop    %edi
8010530a:	5d                   	pop    %ebp
8010530b:	c3                   	ret    
    panic("create: dirlink");
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	68 ea 80 10 80       	push   $0x801080ea
80105314:	e8 77 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	68 cc 80 10 80       	push   $0x801080cc
80105321:	e8 6a b0 ff ff       	call   80100390 <panic>
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi

80105330 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	89 d6                	mov    %edx,%esi
80105336:	53                   	push   %ebx
80105337:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105339:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010533c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010533f:	50                   	push   %eax
80105340:	6a 00                	push   $0x0
80105342:	e8 e9 fc ff ff       	call   80105030 <argint>
80105347:	83 c4 10             	add    $0x10,%esp
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 2a                	js     80105378 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010534e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105352:	77 24                	ja     80105378 <argfd.constprop.0+0x48>
80105354:	e8 87 e8 ff ff       	call   80103be0 <myproc>
80105359:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010535c:	8b 44 90 3c          	mov    0x3c(%eax,%edx,4),%eax
80105360:	85 c0                	test   %eax,%eax
80105362:	74 14                	je     80105378 <argfd.constprop.0+0x48>
  if(pfd)
80105364:	85 db                	test   %ebx,%ebx
80105366:	74 02                	je     8010536a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105368:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010536a:	89 06                	mov    %eax,(%esi)
  return 0;
8010536c:	31 c0                	xor    %eax,%eax
}
8010536e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105371:	5b                   	pop    %ebx
80105372:	5e                   	pop    %esi
80105373:	5d                   	pop    %ebp
80105374:	c3                   	ret    
80105375:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537d:	eb ef                	jmp    8010536e <argfd.constprop.0+0x3e>
8010537f:	90                   	nop

80105380 <sys_dup>:
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105385:	31 c0                	xor    %eax,%eax
{
80105387:	89 e5                	mov    %esp,%ebp
80105389:	56                   	push   %esi
8010538a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010538b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010538e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105391:	e8 9a ff ff ff       	call   80105330 <argfd.constprop.0>
80105396:	85 c0                	test   %eax,%eax
80105398:	78 1e                	js     801053b8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010539a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010539d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010539f:	e8 3c e8 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053a8:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
801053ac:	85 d2                	test   %edx,%edx
801053ae:	74 20                	je     801053d0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801053b0:	83 c3 01             	add    $0x1,%ebx
801053b3:	83 fb 10             	cmp    $0x10,%ebx
801053b6:	75 f0                	jne    801053a8 <sys_dup+0x28>
}
801053b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053c0:	89 d8                	mov    %ebx,%eax
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
801053c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801053d0:	89 74 98 3c          	mov    %esi,0x3c(%eax,%ebx,4)
  filedup(f);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	ff 75 f4             	pushl  -0xc(%ebp)
801053da:	e8 a1 ba ff ff       	call   80100e80 <filedup>
  return fd;
801053df:	83 c4 10             	add    $0x10,%esp
}
801053e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053e5:	89 d8                	mov    %ebx,%eax
801053e7:	5b                   	pop    %ebx
801053e8:	5e                   	pop    %esi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop

801053f0 <sys_read>:
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053f5:	31 c0                	xor    %eax,%eax
{
801053f7:	89 e5                	mov    %esp,%ebp
801053f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053ff:	e8 2c ff ff ff       	call   80105330 <argfd.constprop.0>
80105404:	85 c0                	test   %eax,%eax
80105406:	78 48                	js     80105450 <sys_read+0x60>
80105408:	83 ec 08             	sub    $0x8,%esp
8010540b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010540e:	50                   	push   %eax
8010540f:	6a 02                	push   $0x2
80105411:	e8 1a fc ff ff       	call   80105030 <argint>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 33                	js     80105450 <sys_read+0x60>
8010541d:	83 ec 04             	sub    $0x4,%esp
80105420:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105423:	ff 75 f0             	pushl  -0x10(%ebp)
80105426:	50                   	push   %eax
80105427:	6a 01                	push   $0x1
80105429:	e8 52 fc ff ff       	call   80105080 <argptr>
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	85 c0                	test   %eax,%eax
80105433:	78 1b                	js     80105450 <sys_read+0x60>
  return fileread(f, p, n);
80105435:	83 ec 04             	sub    $0x4,%esp
80105438:	ff 75 f0             	pushl  -0x10(%ebp)
8010543b:	ff 75 f4             	pushl  -0xc(%ebp)
8010543e:	ff 75 ec             	pushl  -0x14(%ebp)
80105441:	e8 ba bb ff ff       	call   80101000 <fileread>
80105446:	83 c4 10             	add    $0x10,%esp
}
80105449:	c9                   	leave  
8010544a:	c3                   	ret    
8010544b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010544f:	90                   	nop
80105450:	c9                   	leave  
    return -1;
80105451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105456:	c3                   	ret    
80105457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545e:	66 90                	xchg   %ax,%ax

80105460 <sys_write>:
{
80105460:	f3 0f 1e fb          	endbr32 
80105464:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105465:	31 c0                	xor    %eax,%eax
{
80105467:	89 e5                	mov    %esp,%ebp
80105469:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010546c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010546f:	e8 bc fe ff ff       	call   80105330 <argfd.constprop.0>
80105474:	85 c0                	test   %eax,%eax
80105476:	78 48                	js     801054c0 <sys_write+0x60>
80105478:	83 ec 08             	sub    $0x8,%esp
8010547b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547e:	50                   	push   %eax
8010547f:	6a 02                	push   $0x2
80105481:	e8 aa fb ff ff       	call   80105030 <argint>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 33                	js     801054c0 <sys_write+0x60>
8010548d:	83 ec 04             	sub    $0x4,%esp
80105490:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105493:	ff 75 f0             	pushl  -0x10(%ebp)
80105496:	50                   	push   %eax
80105497:	6a 01                	push   $0x1
80105499:	e8 e2 fb ff ff       	call   80105080 <argptr>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 1b                	js     801054c0 <sys_write+0x60>
  return filewrite(f, p, n);
801054a5:	83 ec 04             	sub    $0x4,%esp
801054a8:	ff 75 f0             	pushl  -0x10(%ebp)
801054ab:	ff 75 f4             	pushl  -0xc(%ebp)
801054ae:	ff 75 ec             	pushl  -0x14(%ebp)
801054b1:	e8 ea bb ff ff       	call   801010a0 <filewrite>
801054b6:	83 c4 10             	add    $0x10,%esp
}
801054b9:	c9                   	leave  
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop
801054c0:	c9                   	leave  
    return -1;
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054c6:	c3                   	ret    
801054c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <sys_close>:
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801054da:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054e0:	e8 4b fe ff ff       	call   80105330 <argfd.constprop.0>
801054e5:	85 c0                	test   %eax,%eax
801054e7:	78 27                	js     80105510 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801054e9:	e8 f2 e6 ff ff       	call   80103be0 <myproc>
801054ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054f1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054f4:	c7 44 90 3c 00 00 00 	movl   $0x0,0x3c(%eax,%edx,4)
801054fb:	00 
  fileclose(f);
801054fc:	ff 75 f4             	pushl  -0xc(%ebp)
801054ff:	e8 cc b9 ff ff       	call   80100ed0 <fileclose>
  return 0;
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	31 c0                	xor    %eax,%eax
}
80105509:	c9                   	leave  
8010550a:	c3                   	ret    
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
80105510:	c9                   	leave  
    return -1;
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105516:	c3                   	ret    
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax

80105520 <sys_fstat>:
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105525:	31 c0                	xor    %eax,%eax
{
80105527:	89 e5                	mov    %esp,%ebp
80105529:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010552c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010552f:	e8 fc fd ff ff       	call   80105330 <argfd.constprop.0>
80105534:	85 c0                	test   %eax,%eax
80105536:	78 30                	js     80105568 <sys_fstat+0x48>
80105538:	83 ec 04             	sub    $0x4,%esp
8010553b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553e:	6a 14                	push   $0x14
80105540:	50                   	push   %eax
80105541:	6a 01                	push   $0x1
80105543:	e8 38 fb ff ff       	call   80105080 <argptr>
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	85 c0                	test   %eax,%eax
8010554d:	78 19                	js     80105568 <sys_fstat+0x48>
  return filestat(f, st);
8010554f:	83 ec 08             	sub    $0x8,%esp
80105552:	ff 75 f4             	pushl  -0xc(%ebp)
80105555:	ff 75 f0             	pushl  -0x10(%ebp)
80105558:	e8 53 ba ff ff       	call   80100fb0 <filestat>
8010555d:	83 c4 10             	add    $0x10,%esp
}
80105560:	c9                   	leave  
80105561:	c3                   	ret    
80105562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105568:	c9                   	leave  
    return -1;
80105569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556e:	c3                   	ret    
8010556f:	90                   	nop

80105570 <sys_link>:
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	57                   	push   %edi
80105578:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105579:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010557c:	53                   	push   %ebx
8010557d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105580:	50                   	push   %eax
80105581:	6a 00                	push   $0x0
80105583:	e8 58 fb ff ff       	call   801050e0 <argstr>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	0f 88 ff 00 00 00    	js     80105692 <sys_link+0x122>
80105593:	83 ec 08             	sub    $0x8,%esp
80105596:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105599:	50                   	push   %eax
8010559a:	6a 01                	push   $0x1
8010559c:	e8 3f fb ff ff       	call   801050e0 <argstr>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	0f 88 e6 00 00 00    	js     80105692 <sys_link+0x122>
  begin_op();
801055ac:	e8 8f d7 ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801055b1:	83 ec 0c             	sub    $0xc,%esp
801055b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801055b7:	e8 84 ca ff ff       	call   80102040 <namei>
801055bc:	83 c4 10             	add    $0x10,%esp
801055bf:	89 c3                	mov    %eax,%ebx
801055c1:	85 c0                	test   %eax,%eax
801055c3:	0f 84 e8 00 00 00    	je     801056b1 <sys_link+0x141>
  ilock(ip);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	50                   	push   %eax
801055cd:	e8 9e c1 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055da:	0f 84 b9 00 00 00    	je     80105699 <sys_link+0x129>
  iupdate(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801055e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055eb:	53                   	push   %ebx
801055ec:	e8 bf c0 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
801055f1:	89 1c 24             	mov    %ebx,(%esp)
801055f4:	e8 57 c2 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055f9:	58                   	pop    %eax
801055fa:	5a                   	pop    %edx
801055fb:	57                   	push   %edi
801055fc:	ff 75 d0             	pushl  -0x30(%ebp)
801055ff:	e8 5c ca ff ff       	call   80102060 <nameiparent>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	89 c6                	mov    %eax,%esi
80105609:	85 c0                	test   %eax,%eax
8010560b:	74 5f                	je     8010566c <sys_link+0xfc>
  ilock(dp);
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	50                   	push   %eax
80105611:	e8 5a c1 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105616:	8b 03                	mov    (%ebx),%eax
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	39 06                	cmp    %eax,(%esi)
8010561d:	75 41                	jne    80105660 <sys_link+0xf0>
8010561f:	83 ec 04             	sub    $0x4,%esp
80105622:	ff 73 04             	pushl  0x4(%ebx)
80105625:	57                   	push   %edi
80105626:	56                   	push   %esi
80105627:	e8 54 c9 ff ff       	call   80101f80 <dirlink>
8010562c:	83 c4 10             	add    $0x10,%esp
8010562f:	85 c0                	test   %eax,%eax
80105631:	78 2d                	js     80105660 <sys_link+0xf0>
  iunlockput(dp);
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	56                   	push   %esi
80105637:	e8 d4 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
8010563c:	89 1c 24             	mov    %ebx,(%esp)
8010563f:	e8 5c c2 ff ff       	call   801018a0 <iput>
  end_op();
80105644:	e8 67 d7 ff ff       	call   80102db0 <end_op>
  return 0;
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	31 c0                	xor    %eax,%eax
}
8010564e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105651:	5b                   	pop    %ebx
80105652:	5e                   	pop    %esi
80105653:	5f                   	pop    %edi
80105654:	5d                   	pop    %ebp
80105655:	c3                   	ret    
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	56                   	push   %esi
80105664:	e8 a7 c3 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105669:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010566c:	83 ec 0c             	sub    $0xc,%esp
8010566f:	53                   	push   %ebx
80105670:	e8 fb c0 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105675:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010567a:	89 1c 24             	mov    %ebx,(%esp)
8010567d:	e8 2e c0 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105682:	89 1c 24             	mov    %ebx,(%esp)
80105685:	e8 86 c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010568a:	e8 21 d7 ff ff       	call   80102db0 <end_op>
  return -1;
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105697:	eb b5                	jmp    8010564e <sys_link+0xde>
    iunlockput(ip);
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	53                   	push   %ebx
8010569d:	e8 6e c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056a2:	e8 09 d7 ff ff       	call   80102db0 <end_op>
    return -1;
801056a7:	83 c4 10             	add    $0x10,%esp
801056aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056af:	eb 9d                	jmp    8010564e <sys_link+0xde>
    end_op();
801056b1:	e8 fa d6 ff ff       	call   80102db0 <end_op>
    return -1;
801056b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bb:	eb 91                	jmp    8010564e <sys_link+0xde>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi

801056c0 <sys_unlink>:
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	57                   	push   %edi
801056c8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801056c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056cc:	53                   	push   %ebx
801056cd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801056d0:	50                   	push   %eax
801056d1:	6a 00                	push   $0x0
801056d3:	e8 08 fa ff ff       	call   801050e0 <argstr>
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	85 c0                	test   %eax,%eax
801056dd:	0f 88 7d 01 00 00    	js     80105860 <sys_unlink+0x1a0>
  begin_op();
801056e3:	e8 58 d6 ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	53                   	push   %ebx
801056ef:	ff 75 c0             	pushl  -0x40(%ebp)
801056f2:	e8 69 c9 ff ff       	call   80102060 <nameiparent>
801056f7:	83 c4 10             	add    $0x10,%esp
801056fa:	89 c6                	mov    %eax,%esi
801056fc:	85 c0                	test   %eax,%eax
801056fe:	0f 84 66 01 00 00    	je     8010586a <sys_unlink+0x1aa>
  ilock(dp);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	50                   	push   %eax
80105708:	e8 63 c0 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010570d:	58                   	pop    %eax
8010570e:	5a                   	pop    %edx
8010570f:	68 e8 80 10 80       	push   $0x801080e8
80105714:	53                   	push   %ebx
80105715:	e8 86 c5 ff ff       	call   80101ca0 <namecmp>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 84 03 01 00 00    	je     80105828 <sys_unlink+0x168>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	68 e7 80 10 80       	push   $0x801080e7
8010572d:	53                   	push   %ebx
8010572e:	e8 6d c5 ff ff       	call   80101ca0 <namecmp>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	0f 84 ea 00 00 00    	je     80105828 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010573e:	83 ec 04             	sub    $0x4,%esp
80105741:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105744:	50                   	push   %eax
80105745:	53                   	push   %ebx
80105746:	56                   	push   %esi
80105747:	e8 74 c5 ff ff       	call   80101cc0 <dirlookup>
8010574c:	83 c4 10             	add    $0x10,%esp
8010574f:	89 c3                	mov    %eax,%ebx
80105751:	85 c0                	test   %eax,%eax
80105753:	0f 84 cf 00 00 00    	je     80105828 <sys_unlink+0x168>
  ilock(ip);
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	50                   	push   %eax
8010575d:	e8 0e c0 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010576a:	0f 8e 23 01 00 00    	jle    80105893 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105770:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105775:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105778:	74 66                	je     801057e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010577a:	83 ec 04             	sub    $0x4,%esp
8010577d:	6a 10                	push   $0x10
8010577f:	6a 00                	push   $0x0
80105781:	57                   	push   %edi
80105782:	e8 c9 f5 ff ff       	call   80104d50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105787:	6a 10                	push   $0x10
80105789:	ff 75 c4             	pushl  -0x3c(%ebp)
8010578c:	57                   	push   %edi
8010578d:	56                   	push   %esi
8010578e:	e8 dd c3 ff ff       	call   80101b70 <writei>
80105793:	83 c4 20             	add    $0x20,%esp
80105796:	83 f8 10             	cmp    $0x10,%eax
80105799:	0f 85 e7 00 00 00    	jne    80105886 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010579f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057a4:	0f 84 96 00 00 00    	je     80105840 <sys_unlink+0x180>
  iunlockput(dp);
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	56                   	push   %esi
801057ae:	e8 5d c2 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801057b3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057b8:	89 1c 24             	mov    %ebx,(%esp)
801057bb:	e8 f0 be ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
801057c0:	89 1c 24             	mov    %ebx,(%esp)
801057c3:	e8 48 c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057c8:	e8 e3 d5 ff ff       	call   80102db0 <end_op>
  return 0;
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	31 c0                	xor    %eax,%eax
}
801057d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d5:	5b                   	pop    %ebx
801057d6:	5e                   	pop    %esi
801057d7:	5f                   	pop    %edi
801057d8:	5d                   	pop    %ebp
801057d9:	c3                   	ret    
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057e4:	76 94                	jbe    8010577a <sys_unlink+0xba>
801057e6:	ba 20 00 00 00       	mov    $0x20,%edx
801057eb:	eb 0b                	jmp    801057f8 <sys_unlink+0x138>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
801057f0:	83 c2 10             	add    $0x10,%edx
801057f3:	39 53 58             	cmp    %edx,0x58(%ebx)
801057f6:	76 82                	jbe    8010577a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057f8:	6a 10                	push   $0x10
801057fa:	52                   	push   %edx
801057fb:	57                   	push   %edi
801057fc:	53                   	push   %ebx
801057fd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105800:	e8 6b c2 ff ff       	call   80101a70 <readi>
80105805:	83 c4 10             	add    $0x10,%esp
80105808:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010580b:	83 f8 10             	cmp    $0x10,%eax
8010580e:	75 69                	jne    80105879 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105810:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105815:	74 d9                	je     801057f0 <sys_unlink+0x130>
    iunlockput(ip);
80105817:	83 ec 0c             	sub    $0xc,%esp
8010581a:	53                   	push   %ebx
8010581b:	e8 f0 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105820:	83 c4 10             	add    $0x10,%esp
80105823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105827:	90                   	nop
  iunlockput(dp);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	56                   	push   %esi
8010582c:	e8 df c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105831:	e8 7a d5 ff ff       	call   80102db0 <end_op>
  return -1;
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583e:	eb 92                	jmp    801057d2 <sys_unlink+0x112>
    iupdate(dp);
80105840:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105843:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105848:	56                   	push   %esi
80105849:	e8 62 be ff ff       	call   801016b0 <iupdate>
8010584e:	83 c4 10             	add    $0x10,%esp
80105851:	e9 54 ff ff ff       	jmp    801057aa <sys_unlink+0xea>
80105856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	e9 68 ff ff ff       	jmp    801057d2 <sys_unlink+0x112>
    end_op();
8010586a:	e8 41 d5 ff ff       	call   80102db0 <end_op>
    return -1;
8010586f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105874:	e9 59 ff ff ff       	jmp    801057d2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105879:	83 ec 0c             	sub    $0xc,%esp
8010587c:	68 0c 81 10 80       	push   $0x8010810c
80105881:	e8 0a ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105886:	83 ec 0c             	sub    $0xc,%esp
80105889:	68 1e 81 10 80       	push   $0x8010811e
8010588e:	e8 fd aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105893:	83 ec 0c             	sub    $0xc,%esp
80105896:	68 fa 80 10 80       	push   $0x801080fa
8010589b:	e8 f0 aa ff ff       	call   80100390 <panic>

801058a0 <sys_open>:

int
sys_open(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	57                   	push   %edi
801058a8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058ac:	53                   	push   %ebx
801058ad:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058b0:	50                   	push   %eax
801058b1:	6a 00                	push   $0x0
801058b3:	e8 28 f8 ff ff       	call   801050e0 <argstr>
801058b8:	83 c4 10             	add    $0x10,%esp
801058bb:	85 c0                	test   %eax,%eax
801058bd:	0f 88 8a 00 00 00    	js     8010594d <sys_open+0xad>
801058c3:	83 ec 08             	sub    $0x8,%esp
801058c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 01                	push   $0x1
801058cc:	e8 5f f7 ff ff       	call   80105030 <argint>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 75                	js     8010594d <sys_open+0xad>
    return -1;

  begin_op();
801058d8:	e8 63 d4 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
801058dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058e1:	75 75                	jne    80105958 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	ff 75 e0             	pushl  -0x20(%ebp)
801058e9:	e8 52 c7 ff ff       	call   80102040 <namei>
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	89 c6                	mov    %eax,%esi
801058f3:	85 c0                	test   %eax,%eax
801058f5:	74 7e                	je     80105975 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	50                   	push   %eax
801058fb:	e8 70 be ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105908:	0f 84 c2 00 00 00    	je     801059d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010590e:	e8 fd b4 ff ff       	call   80100e10 <filealloc>
80105913:	89 c7                	mov    %eax,%edi
80105915:	85 c0                	test   %eax,%eax
80105917:	74 23                	je     8010593c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105919:	e8 c2 e2 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105920:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
80105924:	85 d2                	test   %edx,%edx
80105926:	74 60                	je     80105988 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105928:	83 c3 01             	add    $0x1,%ebx
8010592b:	83 fb 10             	cmp    $0x10,%ebx
8010592e:	75 f0                	jne    80105920 <sys_open+0x80>
    if(f)
      fileclose(f);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	57                   	push   %edi
80105934:	e8 97 b5 ff ff       	call   80100ed0 <fileclose>
80105939:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	56                   	push   %esi
80105940:	e8 cb c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105945:	e8 66 d4 ff ff       	call   80102db0 <end_op>
    return -1;
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105952:	eb 6d                	jmp    801059c1 <sys_open+0x121>
80105954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010595e:	31 c9                	xor    %ecx,%ecx
80105960:	ba 02 00 00 00       	mov    $0x2,%edx
80105965:	6a 00                	push   $0x0
80105967:	e8 24 f8 ff ff       	call   80105190 <create>
    if(ip == 0){
8010596c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010596f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105971:	85 c0                	test   %eax,%eax
80105973:	75 99                	jne    8010590e <sys_open+0x6e>
      end_op();
80105975:	e8 36 d4 ff ff       	call   80102db0 <end_op>
      return -1;
8010597a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010597f:	eb 40                	jmp    801059c1 <sys_open+0x121>
80105981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105988:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010598b:	89 7c 98 3c          	mov    %edi,0x3c(%eax,%ebx,4)
  iunlock(ip);
8010598f:	56                   	push   %esi
80105990:	e8 bb be ff ff       	call   80101850 <iunlock>
  end_op();
80105995:	e8 16 d4 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
8010599a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059b2:	f7 d0                	not    %eax
801059b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c4:	89 d8                	mov    %ebx,%eax
801059c6:	5b                   	pop    %ebx
801059c7:	5e                   	pop    %esi
801059c8:	5f                   	pop    %edi
801059c9:	5d                   	pop    %ebp
801059ca:	c3                   	ret    
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801059d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059d3:	85 c9                	test   %ecx,%ecx
801059d5:	0f 84 33 ff ff ff    	je     8010590e <sys_open+0x6e>
801059db:	e9 5c ff ff ff       	jmp    8010593c <sys_open+0x9c>

801059e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059e0:	f3 0f 1e fb          	endbr32 
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059ea:	e8 51 d3 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059ef:	83 ec 08             	sub    $0x8,%esp
801059f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f5:	50                   	push   %eax
801059f6:	6a 00                	push   $0x0
801059f8:	e8 e3 f6 ff ff       	call   801050e0 <argstr>
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	85 c0                	test   %eax,%eax
80105a02:	78 34                	js     80105a38 <sys_mkdir+0x58>
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	31 c9                	xor    %ecx,%ecx
80105a0c:	ba 01 00 00 00       	mov    $0x1,%edx
80105a11:	6a 00                	push   $0x0
80105a13:	e8 78 f7 ff ff       	call   80105190 <create>
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	74 19                	je     80105a38 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a1f:	83 ec 0c             	sub    $0xc,%esp
80105a22:	50                   	push   %eax
80105a23:	e8 e8 bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a28:	e8 83 d3 ff ff       	call   80102db0 <end_op>
  return 0;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	31 c0                	xor    %eax,%eax
}
80105a32:	c9                   	leave  
80105a33:	c3                   	ret    
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a38:	e8 73 d3 ff ff       	call   80102db0 <end_op>
    return -1;
80105a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a42:	c9                   	leave  
80105a43:	c3                   	ret    
80105a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a4f:	90                   	nop

80105a50 <sys_mknod>:

int
sys_mknod(void)
{
80105a50:	f3 0f 1e fb          	endbr32 
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a5a:	e8 e1 d2 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a5f:	83 ec 08             	sub    $0x8,%esp
80105a62:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a65:	50                   	push   %eax
80105a66:	6a 00                	push   $0x0
80105a68:	e8 73 f6 ff ff       	call   801050e0 <argstr>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 64                	js     80105ad8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105a74:	83 ec 08             	sub    $0x8,%esp
80105a77:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a7a:	50                   	push   %eax
80105a7b:	6a 01                	push   $0x1
80105a7d:	e8 ae f5 ff ff       	call   80105030 <argint>
  if((argstr(0, &path)) < 0 ||
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	78 4f                	js     80105ad8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a8f:	50                   	push   %eax
80105a90:	6a 02                	push   $0x2
80105a92:	e8 99 f5 ff ff       	call   80105030 <argint>
     argint(1, &major) < 0 ||
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	78 3a                	js     80105ad8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a9e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105aa9:	ba 03 00 00 00       	mov    $0x3,%edx
80105aae:	50                   	push   %eax
80105aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ab2:	e8 d9 f6 ff ff       	call   80105190 <create>
     argint(2, &minor) < 0 ||
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	85 c0                	test   %eax,%eax
80105abc:	74 1a                	je     80105ad8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105abe:	83 ec 0c             	sub    $0xc,%esp
80105ac1:	50                   	push   %eax
80105ac2:	e8 49 bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ac7:	e8 e4 d2 ff ff       	call   80102db0 <end_op>
  return 0;
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	31 c0                	xor    %eax,%eax
}
80105ad1:	c9                   	leave  
80105ad2:	c3                   	ret    
80105ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ad7:	90                   	nop
    end_op();
80105ad8:	e8 d3 d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae2:	c9                   	leave  
80105ae3:	c3                   	ret    
80105ae4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop

80105af0 <sys_chdir>:

int
sys_chdir(void)
{
80105af0:	f3 0f 1e fb          	endbr32 
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	56                   	push   %esi
80105af8:	53                   	push   %ebx
80105af9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105afc:	e8 df e0 ff ff       	call   80103be0 <myproc>
80105b01:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b03:	e8 38 d2 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 ca f5 ff ff       	call   801050e0 <argstr>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	78 73                	js     80105b90 <sys_chdir+0xa0>
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	ff 75 f4             	pushl  -0xc(%ebp)
80105b23:	e8 18 c5 ff ff       	call   80102040 <namei>
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	89 c3                	mov    %eax,%ebx
80105b2d:	85 c0                	test   %eax,%eax
80105b2f:	74 5f                	je     80105b90 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	50                   	push   %eax
80105b35:	e8 36 bc ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b42:	75 2c                	jne    80105b70 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b44:	83 ec 0c             	sub    $0xc,%esp
80105b47:	53                   	push   %ebx
80105b48:	e8 03 bd ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
80105b4d:	58                   	pop    %eax
80105b4e:	ff 76 7c             	pushl  0x7c(%esi)
80105b51:	e8 4a bd ff ff       	call   801018a0 <iput>
  end_op();
80105b56:	e8 55 d2 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105b5b:	89 5e 7c             	mov    %ebx,0x7c(%esi)
  return 0;
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	31 c0                	xor    %eax,%eax
}
80105b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5d                   	pop    %ebp
80105b69:	c3                   	ret    
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	53                   	push   %ebx
80105b74:	e8 97 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b79:	e8 32 d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105b7e:	83 c4 10             	add    $0x10,%esp
80105b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b86:	eb db                	jmp    80105b63 <sys_chdir+0x73>
80105b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
    end_op();
80105b90:	e8 1b d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105b95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9a:	eb c7                	jmp    80105b63 <sys_chdir+0x73>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <sys_exec>:

int
sys_exec(void)
{
80105ba0:	f3 0f 1e fb          	endbr32 
80105ba4:	55                   	push   %ebp
80105ba5:	89 e5                	mov    %esp,%ebp
80105ba7:	57                   	push   %edi
80105ba8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ba9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105baf:	53                   	push   %ebx
80105bb0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bb6:	50                   	push   %eax
80105bb7:	6a 00                	push   $0x0
80105bb9:	e8 22 f5 ff ff       	call   801050e0 <argstr>
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	0f 88 8b 00 00 00    	js     80105c54 <sys_exec+0xb4>
80105bc9:	83 ec 08             	sub    $0x8,%esp
80105bcc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bd2:	50                   	push   %eax
80105bd3:	6a 01                	push   $0x1
80105bd5:	e8 56 f4 ff ff       	call   80105030 <argint>
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	78 73                	js     80105c54 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105be1:	83 ec 04             	sub    $0x4,%esp
80105be4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105bea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bec:	68 80 00 00 00       	push   $0x80
80105bf1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bf7:	6a 00                	push   $0x0
80105bf9:	50                   	push   %eax
80105bfa:	e8 51 f1 ff ff       	call   80104d50 <memset>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c08:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c0e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c15:	83 ec 08             	sub    $0x8,%esp
80105c18:	57                   	push   %edi
80105c19:	01 f0                	add    %esi,%eax
80105c1b:	50                   	push   %eax
80105c1c:	e8 6f f3 ff ff       	call   80104f90 <fetchint>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	78 2c                	js     80105c54 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105c28:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	74 36                	je     80105c68 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c32:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c3e:	52                   	push   %edx
80105c3f:	50                   	push   %eax
80105c40:	e8 8b f3 ff ff       	call   80104fd0 <fetchstr>
80105c45:	83 c4 10             	add    $0x10,%esp
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	78 08                	js     80105c54 <sys_exec+0xb4>
  for(i=0;; i++){
80105c4c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c4f:	83 fb 20             	cmp    $0x20,%ebx
80105c52:	75 b4                	jne    80105c08 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5c:	5b                   	pop    %ebx
80105c5d:	5e                   	pop    %esi
80105c5e:	5f                   	pop    %edi
80105c5f:	5d                   	pop    %ebp
80105c60:	c3                   	ret    
80105c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105c71:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c78:	00 00 00 00 
  return exec(path, argv);
80105c7c:	50                   	push   %eax
80105c7d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c83:	e8 f8 ad ff ff       	call   80100a80 <exec>
80105c88:	83 c4 10             	add    $0x10,%esp
}
80105c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c8e:	5b                   	pop    %ebx
80105c8f:	5e                   	pop    %esi
80105c90:	5f                   	pop    %edi
80105c91:	5d                   	pop    %ebp
80105c92:	c3                   	ret    
80105c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ca0 <sys_pipe>:

int
sys_pipe(void)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	57                   	push   %edi
80105ca8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ca9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105cac:	53                   	push   %ebx
80105cad:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cb0:	6a 08                	push   $0x8
80105cb2:	50                   	push   %eax
80105cb3:	6a 00                	push   $0x0
80105cb5:	e8 c6 f3 ff ff       	call   80105080 <argptr>
80105cba:	83 c4 10             	add    $0x10,%esp
80105cbd:	85 c0                	test   %eax,%eax
80105cbf:	78 4e                	js     80105d0f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105cc1:	83 ec 08             	sub    $0x8,%esp
80105cc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cc7:	50                   	push   %eax
80105cc8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ccb:	50                   	push   %eax
80105ccc:	e8 2f d7 ff ff       	call   80103400 <pipealloc>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	78 37                	js     80105d0f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cd8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105cdb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cdd:	e8 fe de ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ce8:	8b 74 98 3c          	mov    0x3c(%eax,%ebx,4),%esi
80105cec:	85 f6                	test   %esi,%esi
80105cee:	74 30                	je     80105d20 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105cf0:	83 c3 01             	add    $0x1,%ebx
80105cf3:	83 fb 10             	cmp    $0x10,%ebx
80105cf6:	75 f0                	jne    80105ce8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	ff 75 e0             	pushl  -0x20(%ebp)
80105cfe:	e8 cd b1 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105d03:	58                   	pop    %eax
80105d04:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d07:	e8 c4 b1 ff ff       	call   80100ed0 <fileclose>
    return -1;
80105d0c:	83 c4 10             	add    $0x10,%esp
80105d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d14:	eb 5b                	jmp    80105d71 <sys_pipe+0xd1>
80105d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105d20:	8d 73 0c             	lea    0xc(%ebx),%esi
80105d23:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d2a:	e8 b1 de ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d2f:	31 d2                	xor    %edx,%edx
80105d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d38:	8b 4c 90 3c          	mov    0x3c(%eax,%edx,4),%ecx
80105d3c:	85 c9                	test   %ecx,%ecx
80105d3e:	74 20                	je     80105d60 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105d40:	83 c2 01             	add    $0x1,%edx
80105d43:	83 fa 10             	cmp    $0x10,%edx
80105d46:	75 f0                	jne    80105d38 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d48:	e8 93 de ff ff       	call   80103be0 <myproc>
80105d4d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105d54:	00 
80105d55:	eb a1                	jmp    80105cf8 <sys_pipe+0x58>
80105d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d60:	89 7c 90 3c          	mov    %edi,0x3c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d6f:	31 c0                	xor    %eax,%eax
}
80105d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d74:	5b                   	pop    %ebx
80105d75:	5e                   	pop    %esi
80105d76:	5f                   	pop    %edi
80105d77:	5d                   	pop    %ebp
80105d78:	c3                   	ret    
80105d79:	66 90                	xchg   %ax,%ax
80105d7b:	66 90                	xchg   %ax,%ax
80105d7d:	66 90                	xchg   %ax,%ax
80105d7f:	90                   	nop

80105d80 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
  return fork();
80105d84:	e9 07 e0 ff ff       	jmp    80103d90 <fork>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d90 <sys_exit>:
}

int
sys_exit(void)
{
80105d90:	f3 0f 1e fb          	endbr32 
80105d94:	55                   	push   %ebp
80105d95:	89 e5                	mov    %esp,%ebp
80105d97:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d9a:	e8 71 e4 ff ff       	call   80104210 <exit>
  return 0;  // not reached
}
80105d9f:	31 c0                	xor    %eax,%eax
80105da1:	c9                   	leave  
80105da2:	c3                   	ret    
80105da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105db0 <sys_wait>:

int
sys_wait(void)
{
80105db0:	f3 0f 1e fb          	endbr32 
  return wait();
80105db4:	e9 a7 e6 ff ff       	jmp    80104460 <wait>
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105dc0 <sys_kill>:
}

int
sys_kill(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105dca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dcd:	50                   	push   %eax
80105dce:	6a 00                	push   $0x0
80105dd0:	e8 5b f2 ff ff       	call   80105030 <argint>
80105dd5:	83 c4 10             	add    $0x10,%esp
80105dd8:	85 c0                	test   %eax,%eax
80105dda:	78 14                	js     80105df0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ddc:	83 ec 0c             	sub    $0xc,%esp
80105ddf:	ff 75 f4             	pushl  -0xc(%ebp)
80105de2:	e8 f9 e7 ff ff       	call   801045e0 <kill>
80105de7:	83 c4 10             	add    $0x10,%esp
}
80105dea:	c9                   	leave  
80105deb:	c3                   	ret    
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105df0:	c9                   	leave  
    return -1;
80105df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df6:	c3                   	ret    
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <sys_getpid>:

int
sys_getpid(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e0a:	e8 d1 dd ff ff       	call   80103be0 <myproc>
80105e0f:	8b 40 24             	mov    0x24(%eax),%eax
}
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    
80105e14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e1f:	90                   	nop

80105e20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e28:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e2b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e2e:	50                   	push   %eax
80105e2f:	6a 00                	push   $0x0
80105e31:	e8 fa f1 ff ff       	call   80105030 <argint>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 23                	js     80105e60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e3d:	e8 9e dd ff ff       	call   80103be0 <myproc>
  if(growproc(n) < 0)
80105e42:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e45:	8b 58 14             	mov    0x14(%eax),%ebx
  if(growproc(n) < 0)
80105e48:	ff 75 f4             	pushl  -0xc(%ebp)
80105e4b:	e8 c0 de ff ff       	call   80103d10 <growproc>
80105e50:	83 c4 10             	add    $0x10,%esp
80105e53:	85 c0                	test   %eax,%eax
80105e55:	78 09                	js     80105e60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e57:	89 d8                	mov    %ebx,%eax
80105e59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e5c:	c9                   	leave  
80105e5d:	c3                   	ret    
80105e5e:	66 90                	xchg   %ax,%ax
    return -1;
80105e60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e65:	eb f0                	jmp    80105e57 <sys_sbrk+0x37>
80105e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_sleep>:

int
sys_sleep(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
80105e74:	55                   	push   %ebp
80105e75:	89 e5                	mov    %esp,%ebp
80105e77:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e78:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e7b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e7e:	50                   	push   %eax
80105e7f:	6a 00                	push   $0x0
80105e81:	e8 aa f1 ff ff       	call   80105030 <argint>
80105e86:	83 c4 10             	add    $0x10,%esp
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	0f 88 86 00 00 00    	js     80105f17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e91:	83 ec 0c             	sub    $0xc,%esp
80105e94:	68 80 a6 11 80       	push   $0x8011a680
80105e99:	e8 a2 ed ff ff       	call   80104c40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ea1:	8b 1d c0 ae 11 80    	mov    0x8011aec0,%ebx
  while(ticks - ticks0 < n){
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	85 d2                	test   %edx,%edx
80105eac:	75 23                	jne    80105ed1 <sys_sleep+0x61>
80105eae:	eb 50                	jmp    80105f00 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105eb0:	83 ec 08             	sub    $0x8,%esp
80105eb3:	68 80 a6 11 80       	push   $0x8011a680
80105eb8:	68 c0 ae 11 80       	push   $0x8011aec0
80105ebd:	e8 de e4 ff ff       	call   801043a0 <sleep>
  while(ticks - ticks0 < n){
80105ec2:	a1 c0 ae 11 80       	mov    0x8011aec0,%eax
80105ec7:	83 c4 10             	add    $0x10,%esp
80105eca:	29 d8                	sub    %ebx,%eax
80105ecc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ecf:	73 2f                	jae    80105f00 <sys_sleep+0x90>
    if(myproc()->killed){
80105ed1:	e8 0a dd ff ff       	call   80103be0 <myproc>
80105ed6:	8b 40 38             	mov    0x38(%eax),%eax
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	74 d3                	je     80105eb0 <sys_sleep+0x40>
      release(&tickslock);
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	68 80 a6 11 80       	push   $0x8011a680
80105ee5:	e8 16 ee ff ff       	call   80104d00 <release>
  }
  release(&tickslock);
  return 0;
}
80105eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105eed:	83 c4 10             	add    $0x10,%esp
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
80105ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	68 80 a6 11 80       	push   $0x8011a680
80105f08:	e8 f3 ed ff ff       	call   80104d00 <release>
  return 0;
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	31 c0                	xor    %eax,%eax
}
80105f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f15:	c9                   	leave  
80105f16:	c3                   	ret    
    return -1;
80105f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1c:	eb f4                	jmp    80105f12 <sys_sleep+0xa2>
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	53                   	push   %ebx
80105f28:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f2b:	68 80 a6 11 80       	push   $0x8011a680
80105f30:	e8 0b ed ff ff       	call   80104c40 <acquire>
  xticks = ticks;
80105f35:	8b 1d c0 ae 11 80    	mov    0x8011aec0,%ebx
  release(&tickslock);
80105f3b:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
80105f42:	e8 b9 ed ff ff       	call   80104d00 <release>
  return xticks;
}
80105f47:	89 d8                	mov    %ebx,%eax
80105f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f4c:	c9                   	leave  
80105f4d:	c3                   	ret    
80105f4e:	66 90                	xchg   %ax,%ax

80105f50 <sys_prio>:

int sys_prio(void){
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	83 ec 08             	sub    $0x8,%esp
  return myproc()->prio;
80105f5a:	e8 81 dc ff ff       	call   80103be0 <myproc>
80105f5f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f62:	c9                   	leave  
80105f63:	c3                   	ret    
80105f64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f6f:	90                   	nop

80105f70 <sys_cps>:

int sys_cps(void){
80105f70:	f3 0f 1e fb          	endbr32 
  return cps();
80105f74:	e9 d7 e7 ff ff       	jmp    80104750 <cps>
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_chpr>:
}

int sys_chpr(void){
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0) return -1;
80105f8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f8d:	50                   	push   %eax
80105f8e:	6a 00                	push   $0x0
80105f90:	e8 9b f0 ff ff       	call   80105030 <argint>
80105f95:	83 c4 10             	add    $0x10,%esp
80105f98:	85 c0                	test   %eax,%eax
80105f9a:	78 2c                	js     80105fc8 <sys_chpr+0x48>
  if(argint(1, &pr) < 0) return -1;
80105f9c:	83 ec 08             	sub    $0x8,%esp
80105f9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fa2:	50                   	push   %eax
80105fa3:	6a 01                	push   $0x1
80105fa5:	e8 86 f0 ff ff       	call   80105030 <argint>
80105faa:	83 c4 10             	add    $0x10,%esp
80105fad:	85 c0                	test   %eax,%eax
80105faf:	78 17                	js     80105fc8 <sys_chpr+0x48>

  return chpr(pid, pr);
80105fb1:	83 ec 08             	sub    $0x8,%esp
80105fb4:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb7:	ff 75 f0             	pushl  -0x10(%ebp)
80105fba:	e8 91 e8 ff ff       	call   80104850 <chpr>
80105fbf:	83 c4 10             	add    $0x10,%esp
}
80105fc2:	c9                   	leave  
80105fc3:	c3                   	ret    
80105fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fc8:	c9                   	leave  
  if(argint(0, &pid) < 0) return -1;
80105fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fce:	c3                   	ret    
80105fcf:	90                   	nop

80105fd0 <sys_wtp>:

int sys_wtp(void){
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0) return -1;
80105fda:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fdd:	50                   	push   %eax
80105fde:	6a 00                	push   $0x0
80105fe0:	e8 4b f0 ff ff       	call   80105030 <argint>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	85 c0                	test   %eax,%eax
80105fea:	78 24                	js     80106010 <sys_wtp+0x40>
  cprintf("process number %d\n", pid);
80105fec:	83 ec 08             	sub    $0x8,%esp
80105fef:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff2:	68 2d 81 10 80       	push   $0x8010812d
80105ff7:	e8 b4 a6 ff ff       	call   801006b0 <cprintf>
  withput_ticket_proc(pid);
80105ffc:	58                   	pop    %eax
80105ffd:	ff 75 f4             	pushl  -0xc(%ebp)
80106000:	e8 cb e8 ff ff       	call   801048d0 <withput_ticket_proc>
  return 0;
80106005:	83 c4 10             	add    $0x10,%esp
80106008:	31 c0                	xor    %eax,%eax
}
8010600a:	c9                   	leave  
8010600b:	c3                   	ret    
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106010:	c9                   	leave  
  if(argint(0, &pid) < 0) return -1;
80106011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106016:	c3                   	ret    
80106017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601e:	66 90                	xchg   %ax,%ax

80106020 <sys_changeTicket>:

int sys_changeTicket(void){
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket;
  if(argint(0, &pid) < 0) return -1;
8010602a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010602d:	50                   	push   %eax
8010602e:	6a 00                	push   $0x0
80106030:	e8 fb ef ff ff       	call   80105030 <argint>
80106035:	83 c4 10             	add    $0x10,%esp
80106038:	85 c0                	test   %eax,%eax
8010603a:	78 2c                	js     80106068 <sys_changeTicket+0x48>
  if(argint(1, &ticket) < 0) return -1;
8010603c:	83 ec 08             	sub    $0x8,%esp
8010603f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106042:	50                   	push   %eax
80106043:	6a 01                	push   $0x1
80106045:	e8 e6 ef ff ff       	call   80105030 <argint>
8010604a:	83 c4 10             	add    $0x10,%esp
8010604d:	85 c0                	test   %eax,%eax
8010604f:	78 17                	js     80106068 <sys_changeTicket+0x48>

  return proc_ticket(pid, ticket);
80106051:	83 ec 08             	sub    $0x8,%esp
80106054:	ff 75 f4             	pushl  -0xc(%ebp)
80106057:	ff 75 f0             	pushl  -0x10(%ebp)
8010605a:	e8 c1 e8 ff ff       	call   80104920 <proc_ticket>
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	c9                   	leave  
80106063:	c3                   	ret    
80106064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106068:	c9                   	leave  
  if(argint(0, &pid) < 0) return -1;
80106069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606e:	c3                   	ret    

8010606f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010606f:	1e                   	push   %ds
  pushl %es
80106070:	06                   	push   %es
  pushl %fs
80106071:	0f a0                	push   %fs
  pushl %gs
80106073:	0f a8                	push   %gs
  pushal
80106075:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106076:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010607a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010607c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010607e:	54                   	push   %esp
  call trap
8010607f:	e8 cc 00 00 00       	call   80106150 <trap>
  addl $4, %esp
80106084:	83 c4 04             	add    $0x4,%esp

80106087 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106087:	61                   	popa   
  popl %gs
80106088:	0f a9                	pop    %gs
  popl %fs
8010608a:	0f a1                	pop    %fs
  popl %es
8010608c:	07                   	pop    %es
  popl %ds
8010608d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010608e:	83 c4 08             	add    $0x8,%esp
  iret
80106091:	cf                   	iret   
80106092:	66 90                	xchg   %ax,%ax
80106094:	66 90                	xchg   %ax,%ax
80106096:	66 90                	xchg   %ax,%ax
80106098:	66 90                	xchg   %ax,%ax
8010609a:	66 90                	xchg   %ax,%ax
8010609c:	66 90                	xchg   %ax,%ax
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060a0:	f3 0f 1e fb          	endbr32 
801060a4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801060a5:	31 c0                	xor    %eax,%eax
{
801060a7:	89 e5                	mov    %esp,%ebp
801060a9:	83 ec 08             	sub    $0x8,%esp
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060b0:	8b 14 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%edx
801060b7:	c7 04 c5 c2 a6 11 80 	movl   $0x8e000008,-0x7fee593e(,%eax,8)
801060be:	08 00 00 8e 
801060c2:	66 89 14 c5 c0 a6 11 	mov    %dx,-0x7fee5940(,%eax,8)
801060c9:	80 
801060ca:	c1 ea 10             	shr    $0x10,%edx
801060cd:	66 89 14 c5 c6 a6 11 	mov    %dx,-0x7fee593a(,%eax,8)
801060d4:	80 
  for(i = 0; i < 256; i++)
801060d5:	83 c0 01             	add    $0x1,%eax
801060d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801060dd:	75 d1                	jne    801060b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801060df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060e2:	a1 20 b1 10 80       	mov    0x8010b120,%eax
801060e7:	c7 05 c2 a8 11 80 08 	movl   $0xef000008,0x8011a8c2
801060ee:	00 00 ef 
  initlock(&tickslock, "time");
801060f1:	68 40 81 10 80       	push   $0x80108140
801060f6:	68 80 a6 11 80       	push   $0x8011a680
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060fb:	66 a3 c0 a8 11 80    	mov    %ax,0x8011a8c0
80106101:	c1 e8 10             	shr    $0x10,%eax
80106104:	66 a3 c6 a8 11 80    	mov    %ax,0x8011a8c6
  initlock(&tickslock, "time");
8010610a:	e8 b1 e9 ff ff       	call   80104ac0 <initlock>
}
8010610f:	83 c4 10             	add    $0x10,%esp
80106112:	c9                   	leave  
80106113:	c3                   	ret    
80106114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop

80106120 <idtinit>:

void
idtinit(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
  pd[0] = size-1;
80106125:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010612a:	89 e5                	mov    %esp,%ebp
8010612c:	83 ec 10             	sub    $0x10,%esp
8010612f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106133:	b8 c0 a6 11 80       	mov    $0x8011a6c0,%eax
80106138:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010613c:	c1 e8 10             	shr    $0x10,%eax
8010613f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106143:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106146:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106149:	c9                   	leave  
8010614a:	c3                   	ret    
8010614b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010614f:	90                   	nop

80106150 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	56                   	push   %esi
80106159:	53                   	push   %ebx
8010615a:	83 ec 1c             	sub    $0x1c,%esp
8010615d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106160:	8b 43 30             	mov    0x30(%ebx),%eax
80106163:	83 f8 40             	cmp    $0x40,%eax
80106166:	0f 84 bc 01 00 00    	je     80106328 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010616c:	83 e8 20             	sub    $0x20,%eax
8010616f:	83 f8 1f             	cmp    $0x1f,%eax
80106172:	77 08                	ja     8010617c <trap+0x2c>
80106174:	3e ff 24 85 e8 81 10 	notrack jmp *-0x7fef7e18(,%eax,4)
8010617b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010617c:	e8 5f da ff ff       	call   80103be0 <myproc>
80106181:	8b 7b 38             	mov    0x38(%ebx),%edi
80106184:	85 c0                	test   %eax,%eax
80106186:	0f 84 eb 01 00 00    	je     80106377 <trap+0x227>
8010618c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106190:	0f 84 e1 01 00 00    	je     80106377 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106196:	0f 20 d1             	mov    %cr2,%ecx
80106199:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010619c:	e8 1f da ff ff       	call   80103bc0 <cpuid>
801061a1:	8b 73 30             	mov    0x30(%ebx),%esi
801061a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801061a7:	8b 43 34             	mov    0x34(%ebx),%eax
801061aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061ad:	e8 2e da ff ff       	call   80103be0 <myproc>
801061b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061b5:	e8 26 da ff ff       	call   80103be0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061ba:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061c0:	51                   	push   %ecx
801061c1:	57                   	push   %edi
801061c2:	52                   	push   %edx
801061c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801061c6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801061c7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801061ca:	83 ee 80             	sub    $0xffffff80,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061cd:	56                   	push   %esi
801061ce:	ff 70 24             	pushl  0x24(%eax)
801061d1:	68 a4 81 10 80       	push   $0x801081a4
801061d6:	e8 d5 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801061db:	83 c4 20             	add    $0x20,%esp
801061de:	e8 fd d9 ff ff       	call   80103be0 <myproc>
801061e3:	c7 40 38 01 00 00 00 	movl   $0x1,0x38(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ea:	e8 f1 d9 ff ff       	call   80103be0 <myproc>
801061ef:	85 c0                	test   %eax,%eax
801061f1:	74 1d                	je     80106210 <trap+0xc0>
801061f3:	e8 e8 d9 ff ff       	call   80103be0 <myproc>
801061f8:	8b 50 38             	mov    0x38(%eax),%edx
801061fb:	85 d2                	test   %edx,%edx
801061fd:	74 11                	je     80106210 <trap+0xc0>
801061ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106203:	83 e0 03             	and    $0x3,%eax
80106206:	66 83 f8 03          	cmp    $0x3,%ax
8010620a:	0f 84 50 01 00 00    	je     80106360 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106210:	e8 cb d9 ff ff       	call   80103be0 <myproc>
80106215:	85 c0                	test   %eax,%eax
80106217:	74 0f                	je     80106228 <trap+0xd8>
80106219:	e8 c2 d9 ff ff       	call   80103be0 <myproc>
8010621e:	83 78 20 04          	cmpl   $0x4,0x20(%eax)
80106222:	0f 84 e8 00 00 00    	je     80106310 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106228:	e8 b3 d9 ff ff       	call   80103be0 <myproc>
8010622d:	85 c0                	test   %eax,%eax
8010622f:	74 1d                	je     8010624e <trap+0xfe>
80106231:	e8 aa d9 ff ff       	call   80103be0 <myproc>
80106236:	8b 40 38             	mov    0x38(%eax),%eax
80106239:	85 c0                	test   %eax,%eax
8010623b:	74 11                	je     8010624e <trap+0xfe>
8010623d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106241:	83 e0 03             	and    $0x3,%eax
80106244:	66 83 f8 03          	cmp    $0x3,%ax
80106248:	0f 84 03 01 00 00    	je     80106351 <trap+0x201>
    exit();
}
8010624e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106251:	5b                   	pop    %ebx
80106252:	5e                   	pop    %esi
80106253:	5f                   	pop    %edi
80106254:	5d                   	pop    %ebp
80106255:	c3                   	ret    
    ideintr();
80106256:	e8 95 bf ff ff       	call   801021f0 <ideintr>
    lapiceoi();
8010625b:	e8 70 c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106260:	e8 7b d9 ff ff       	call   80103be0 <myproc>
80106265:	85 c0                	test   %eax,%eax
80106267:	75 8a                	jne    801061f3 <trap+0xa3>
80106269:	eb a5                	jmp    80106210 <trap+0xc0>
    if(cpuid() == 0){
8010626b:	e8 50 d9 ff ff       	call   80103bc0 <cpuid>
80106270:	85 c0                	test   %eax,%eax
80106272:	75 e7                	jne    8010625b <trap+0x10b>
      acquire(&tickslock);
80106274:	83 ec 0c             	sub    $0xc,%esp
80106277:	68 80 a6 11 80       	push   $0x8011a680
8010627c:	e8 bf e9 ff ff       	call   80104c40 <acquire>
      wakeup(&ticks);
80106281:	c7 04 24 c0 ae 11 80 	movl   $0x8011aec0,(%esp)
      ticks++;
80106288:	83 05 c0 ae 11 80 01 	addl   $0x1,0x8011aec0
      wakeup(&ticks);
8010628f:	e8 dc e2 ff ff       	call   80104570 <wakeup>
      release(&tickslock);
80106294:	c7 04 24 80 a6 11 80 	movl   $0x8011a680,(%esp)
8010629b:	e8 60 ea ff ff       	call   80104d00 <release>
801062a0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062a3:	eb b6                	jmp    8010625b <trap+0x10b>
    kbdintr();
801062a5:	e8 e6 c4 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
801062aa:	e8 21 c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062af:	e8 2c d9 ff ff       	call   80103be0 <myproc>
801062b4:	85 c0                	test   %eax,%eax
801062b6:	0f 85 37 ff ff ff    	jne    801061f3 <trap+0xa3>
801062bc:	e9 4f ff ff ff       	jmp    80106210 <trap+0xc0>
    uartintr();
801062c1:	e8 4a 02 00 00       	call   80106510 <uartintr>
    lapiceoi();
801062c6:	e8 05 c6 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062cb:	e8 10 d9 ff ff       	call   80103be0 <myproc>
801062d0:	85 c0                	test   %eax,%eax
801062d2:	0f 85 1b ff ff ff    	jne    801061f3 <trap+0xa3>
801062d8:	e9 33 ff ff ff       	jmp    80106210 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062dd:	8b 7b 38             	mov    0x38(%ebx),%edi
801062e0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801062e4:	e8 d7 d8 ff ff       	call   80103bc0 <cpuid>
801062e9:	57                   	push   %edi
801062ea:	56                   	push   %esi
801062eb:	50                   	push   %eax
801062ec:	68 4c 81 10 80       	push   $0x8010814c
801062f1:	e8 ba a3 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801062f6:	e8 d5 c5 ff ff       	call   801028d0 <lapiceoi>
    break;
801062fb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062fe:	e8 dd d8 ff ff       	call   80103be0 <myproc>
80106303:	85 c0                	test   %eax,%eax
80106305:	0f 85 e8 fe ff ff    	jne    801061f3 <trap+0xa3>
8010630b:	e9 00 ff ff ff       	jmp    80106210 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106310:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106314:	0f 85 0e ff ff ff    	jne    80106228 <trap+0xd8>
    yield();
8010631a:	e8 31 e0 ff ff       	call   80104350 <yield>
8010631f:	e9 04 ff ff ff       	jmp    80106228 <trap+0xd8>
80106324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106328:	e8 b3 d8 ff ff       	call   80103be0 <myproc>
8010632d:	8b 70 38             	mov    0x38(%eax),%esi
80106330:	85 f6                	test   %esi,%esi
80106332:	75 3c                	jne    80106370 <trap+0x220>
    myproc()->tf = tf;
80106334:	e8 a7 d8 ff ff       	call   80103be0 <myproc>
80106339:	89 58 2c             	mov    %ebx,0x2c(%eax)
    syscall();
8010633c:	e8 df ed ff ff       	call   80105120 <syscall>
    if(myproc()->killed)
80106341:	e8 9a d8 ff ff       	call   80103be0 <myproc>
80106346:	8b 48 38             	mov    0x38(%eax),%ecx
80106349:	85 c9                	test   %ecx,%ecx
8010634b:	0f 84 fd fe ff ff    	je     8010624e <trap+0xfe>
}
80106351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106354:	5b                   	pop    %ebx
80106355:	5e                   	pop    %esi
80106356:	5f                   	pop    %edi
80106357:	5d                   	pop    %ebp
      exit();
80106358:	e9 b3 de ff ff       	jmp    80104210 <exit>
8010635d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106360:	e8 ab de ff ff       	call   80104210 <exit>
80106365:	e9 a6 fe ff ff       	jmp    80106210 <trap+0xc0>
8010636a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106370:	e8 9b de ff ff       	call   80104210 <exit>
80106375:	eb bd                	jmp    80106334 <trap+0x1e4>
80106377:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010637a:	e8 41 d8 ff ff       	call   80103bc0 <cpuid>
8010637f:	83 ec 0c             	sub    $0xc,%esp
80106382:	56                   	push   %esi
80106383:	57                   	push   %edi
80106384:	50                   	push   %eax
80106385:	ff 73 30             	pushl  0x30(%ebx)
80106388:	68 70 81 10 80       	push   $0x80108170
8010638d:	e8 1e a3 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106392:	83 c4 14             	add    $0x14,%esp
80106395:	68 45 81 10 80       	push   $0x80108145
8010639a:	e8 f1 9f ff ff       	call   80100390 <panic>
8010639f:	90                   	nop

801063a0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801063a0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801063a4:	a1 a0 fa 10 80       	mov    0x8010faa0,%eax
801063a9:	85 c0                	test   %eax,%eax
801063ab:	74 1b                	je     801063c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063b2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063b3:	a8 01                	test   $0x1,%al
801063b5:	74 11                	je     801063c8 <uartgetc+0x28>
801063b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063bc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063bd:	0f b6 c0             	movzbl %al,%eax
801063c0:	c3                   	ret    
801063c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063cd:	c3                   	ret    
801063ce:	66 90                	xchg   %ax,%ax

801063d0 <uartputc.part.0>:
uartputc(int c)
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	57                   	push   %edi
801063d4:	89 c7                	mov    %eax,%edi
801063d6:	56                   	push   %esi
801063d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801063dc:	53                   	push   %ebx
801063dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801063e2:	83 ec 0c             	sub    $0xc,%esp
801063e5:	eb 1b                	jmp    80106402 <uartputc.part.0+0x32>
801063e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ee:	66 90                	xchg   %ax,%ax
    microdelay(10);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	6a 0a                	push   $0xa
801063f5:	e8 f6 c4 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063fa:	83 c4 10             	add    $0x10,%esp
801063fd:	83 eb 01             	sub    $0x1,%ebx
80106400:	74 07                	je     80106409 <uartputc.part.0+0x39>
80106402:	89 f2                	mov    %esi,%edx
80106404:	ec                   	in     (%dx),%al
80106405:	a8 20                	test   $0x20,%al
80106407:	74 e7                	je     801063f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106409:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010640e:	89 f8                	mov    %edi,%eax
80106410:	ee                   	out    %al,(%dx)
}
80106411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106414:	5b                   	pop    %ebx
80106415:	5e                   	pop    %esi
80106416:	5f                   	pop    %edi
80106417:	5d                   	pop    %ebp
80106418:	c3                   	ret    
80106419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106420 <uartinit>:
{
80106420:	f3 0f 1e fb          	endbr32 
80106424:	55                   	push   %ebp
80106425:	31 c9                	xor    %ecx,%ecx
80106427:	89 c8                	mov    %ecx,%eax
80106429:	89 e5                	mov    %esp,%ebp
8010642b:	57                   	push   %edi
8010642c:	56                   	push   %esi
8010642d:	53                   	push   %ebx
8010642e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106433:	89 da                	mov    %ebx,%edx
80106435:	83 ec 0c             	sub    $0xc,%esp
80106438:	ee                   	out    %al,(%dx)
80106439:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010643e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106443:	89 fa                	mov    %edi,%edx
80106445:	ee                   	out    %al,(%dx)
80106446:	b8 0c 00 00 00       	mov    $0xc,%eax
8010644b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106450:	ee                   	out    %al,(%dx)
80106451:	be f9 03 00 00       	mov    $0x3f9,%esi
80106456:	89 c8                	mov    %ecx,%eax
80106458:	89 f2                	mov    %esi,%edx
8010645a:	ee                   	out    %al,(%dx)
8010645b:	b8 03 00 00 00       	mov    $0x3,%eax
80106460:	89 fa                	mov    %edi,%edx
80106462:	ee                   	out    %al,(%dx)
80106463:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106468:	89 c8                	mov    %ecx,%eax
8010646a:	ee                   	out    %al,(%dx)
8010646b:	b8 01 00 00 00       	mov    $0x1,%eax
80106470:	89 f2                	mov    %esi,%edx
80106472:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106473:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106478:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106479:	3c ff                	cmp    $0xff,%al
8010647b:	74 52                	je     801064cf <uartinit+0xaf>
  uart = 1;
8010647d:	c7 05 a0 fa 10 80 01 	movl   $0x1,0x8010faa0
80106484:	00 00 00 
80106487:	89 da                	mov    %ebx,%edx
80106489:	ec                   	in     (%dx),%al
8010648a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106490:	83 ec 08             	sub    $0x8,%esp
80106493:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106498:	bb 68 82 10 80       	mov    $0x80108268,%ebx
  ioapicenable(IRQ_COM1, 0);
8010649d:	6a 00                	push   $0x0
8010649f:	6a 04                	push   $0x4
801064a1:	e8 9a bf ff ff       	call   80102440 <ioapicenable>
801064a6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801064a9:	b8 78 00 00 00       	mov    $0x78,%eax
801064ae:	eb 04                	jmp    801064b4 <uartinit+0x94>
801064b0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801064b4:	8b 15 a0 fa 10 80    	mov    0x8010faa0,%edx
801064ba:	85 d2                	test   %edx,%edx
801064bc:	74 08                	je     801064c6 <uartinit+0xa6>
    uartputc(*p);
801064be:	0f be c0             	movsbl %al,%eax
801064c1:	e8 0a ff ff ff       	call   801063d0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801064c6:	89 f0                	mov    %esi,%eax
801064c8:	83 c3 01             	add    $0x1,%ebx
801064cb:	84 c0                	test   %al,%al
801064cd:	75 e1                	jne    801064b0 <uartinit+0x90>
}
801064cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d2:	5b                   	pop    %ebx
801064d3:	5e                   	pop    %esi
801064d4:	5f                   	pop    %edi
801064d5:	5d                   	pop    %ebp
801064d6:	c3                   	ret    
801064d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064de:	66 90                	xchg   %ax,%ax

801064e0 <uartputc>:
{
801064e0:	f3 0f 1e fb          	endbr32 
801064e4:	55                   	push   %ebp
  if(!uart)
801064e5:	8b 15 a0 fa 10 80    	mov    0x8010faa0,%edx
{
801064eb:	89 e5                	mov    %esp,%ebp
801064ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801064f0:	85 d2                	test   %edx,%edx
801064f2:	74 0c                	je     80106500 <uartputc+0x20>
}
801064f4:	5d                   	pop    %ebp
801064f5:	e9 d6 fe ff ff       	jmp    801063d0 <uartputc.part.0>
801064fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106500:	5d                   	pop    %ebp
80106501:	c3                   	ret    
80106502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106510 <uartintr>:

void
uartintr(void)
{
80106510:	f3 0f 1e fb          	endbr32 
80106514:	55                   	push   %ebp
80106515:	89 e5                	mov    %esp,%ebp
80106517:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010651a:	68 a0 63 10 80       	push   $0x801063a0
8010651f:	e8 3c a3 ff ff       	call   80100860 <consoleintr>
}
80106524:	83 c4 10             	add    $0x10,%esp
80106527:	c9                   	leave  
80106528:	c3                   	ret    

80106529 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $0
8010652b:	6a 00                	push   $0x0
  jmp alltraps
8010652d:	e9 3d fb ff ff       	jmp    8010606f <alltraps>

80106532 <vector1>:
.globl vector1
vector1:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $1
80106534:	6a 01                	push   $0x1
  jmp alltraps
80106536:	e9 34 fb ff ff       	jmp    8010606f <alltraps>

8010653b <vector2>:
.globl vector2
vector2:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $2
8010653d:	6a 02                	push   $0x2
  jmp alltraps
8010653f:	e9 2b fb ff ff       	jmp    8010606f <alltraps>

80106544 <vector3>:
.globl vector3
vector3:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $3
80106546:	6a 03                	push   $0x3
  jmp alltraps
80106548:	e9 22 fb ff ff       	jmp    8010606f <alltraps>

8010654d <vector4>:
.globl vector4
vector4:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $4
8010654f:	6a 04                	push   $0x4
  jmp alltraps
80106551:	e9 19 fb ff ff       	jmp    8010606f <alltraps>

80106556 <vector5>:
.globl vector5
vector5:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $5
80106558:	6a 05                	push   $0x5
  jmp alltraps
8010655a:	e9 10 fb ff ff       	jmp    8010606f <alltraps>

8010655f <vector6>:
.globl vector6
vector6:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $6
80106561:	6a 06                	push   $0x6
  jmp alltraps
80106563:	e9 07 fb ff ff       	jmp    8010606f <alltraps>

80106568 <vector7>:
.globl vector7
vector7:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $7
8010656a:	6a 07                	push   $0x7
  jmp alltraps
8010656c:	e9 fe fa ff ff       	jmp    8010606f <alltraps>

80106571 <vector8>:
.globl vector8
vector8:
  pushl $8
80106571:	6a 08                	push   $0x8
  jmp alltraps
80106573:	e9 f7 fa ff ff       	jmp    8010606f <alltraps>

80106578 <vector9>:
.globl vector9
vector9:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $9
8010657a:	6a 09                	push   $0x9
  jmp alltraps
8010657c:	e9 ee fa ff ff       	jmp    8010606f <alltraps>

80106581 <vector10>:
.globl vector10
vector10:
  pushl $10
80106581:	6a 0a                	push   $0xa
  jmp alltraps
80106583:	e9 e7 fa ff ff       	jmp    8010606f <alltraps>

80106588 <vector11>:
.globl vector11
vector11:
  pushl $11
80106588:	6a 0b                	push   $0xb
  jmp alltraps
8010658a:	e9 e0 fa ff ff       	jmp    8010606f <alltraps>

8010658f <vector12>:
.globl vector12
vector12:
  pushl $12
8010658f:	6a 0c                	push   $0xc
  jmp alltraps
80106591:	e9 d9 fa ff ff       	jmp    8010606f <alltraps>

80106596 <vector13>:
.globl vector13
vector13:
  pushl $13
80106596:	6a 0d                	push   $0xd
  jmp alltraps
80106598:	e9 d2 fa ff ff       	jmp    8010606f <alltraps>

8010659d <vector14>:
.globl vector14
vector14:
  pushl $14
8010659d:	6a 0e                	push   $0xe
  jmp alltraps
8010659f:	e9 cb fa ff ff       	jmp    8010606f <alltraps>

801065a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $15
801065a6:	6a 0f                	push   $0xf
  jmp alltraps
801065a8:	e9 c2 fa ff ff       	jmp    8010606f <alltraps>

801065ad <vector16>:
.globl vector16
vector16:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $16
801065af:	6a 10                	push   $0x10
  jmp alltraps
801065b1:	e9 b9 fa ff ff       	jmp    8010606f <alltraps>

801065b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801065b6:	6a 11                	push   $0x11
  jmp alltraps
801065b8:	e9 b2 fa ff ff       	jmp    8010606f <alltraps>

801065bd <vector18>:
.globl vector18
vector18:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $18
801065bf:	6a 12                	push   $0x12
  jmp alltraps
801065c1:	e9 a9 fa ff ff       	jmp    8010606f <alltraps>

801065c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $19
801065c8:	6a 13                	push   $0x13
  jmp alltraps
801065ca:	e9 a0 fa ff ff       	jmp    8010606f <alltraps>

801065cf <vector20>:
.globl vector20
vector20:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $20
801065d1:	6a 14                	push   $0x14
  jmp alltraps
801065d3:	e9 97 fa ff ff       	jmp    8010606f <alltraps>

801065d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $21
801065da:	6a 15                	push   $0x15
  jmp alltraps
801065dc:	e9 8e fa ff ff       	jmp    8010606f <alltraps>

801065e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $22
801065e3:	6a 16                	push   $0x16
  jmp alltraps
801065e5:	e9 85 fa ff ff       	jmp    8010606f <alltraps>

801065ea <vector23>:
.globl vector23
vector23:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $23
801065ec:	6a 17                	push   $0x17
  jmp alltraps
801065ee:	e9 7c fa ff ff       	jmp    8010606f <alltraps>

801065f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $24
801065f5:	6a 18                	push   $0x18
  jmp alltraps
801065f7:	e9 73 fa ff ff       	jmp    8010606f <alltraps>

801065fc <vector25>:
.globl vector25
vector25:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $25
801065fe:	6a 19                	push   $0x19
  jmp alltraps
80106600:	e9 6a fa ff ff       	jmp    8010606f <alltraps>

80106605 <vector26>:
.globl vector26
vector26:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $26
80106607:	6a 1a                	push   $0x1a
  jmp alltraps
80106609:	e9 61 fa ff ff       	jmp    8010606f <alltraps>

8010660e <vector27>:
.globl vector27
vector27:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $27
80106610:	6a 1b                	push   $0x1b
  jmp alltraps
80106612:	e9 58 fa ff ff       	jmp    8010606f <alltraps>

80106617 <vector28>:
.globl vector28
vector28:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $28
80106619:	6a 1c                	push   $0x1c
  jmp alltraps
8010661b:	e9 4f fa ff ff       	jmp    8010606f <alltraps>

80106620 <vector29>:
.globl vector29
vector29:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $29
80106622:	6a 1d                	push   $0x1d
  jmp alltraps
80106624:	e9 46 fa ff ff       	jmp    8010606f <alltraps>

80106629 <vector30>:
.globl vector30
vector30:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $30
8010662b:	6a 1e                	push   $0x1e
  jmp alltraps
8010662d:	e9 3d fa ff ff       	jmp    8010606f <alltraps>

80106632 <vector31>:
.globl vector31
vector31:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $31
80106634:	6a 1f                	push   $0x1f
  jmp alltraps
80106636:	e9 34 fa ff ff       	jmp    8010606f <alltraps>

8010663b <vector32>:
.globl vector32
vector32:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $32
8010663d:	6a 20                	push   $0x20
  jmp alltraps
8010663f:	e9 2b fa ff ff       	jmp    8010606f <alltraps>

80106644 <vector33>:
.globl vector33
vector33:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $33
80106646:	6a 21                	push   $0x21
  jmp alltraps
80106648:	e9 22 fa ff ff       	jmp    8010606f <alltraps>

8010664d <vector34>:
.globl vector34
vector34:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $34
8010664f:	6a 22                	push   $0x22
  jmp alltraps
80106651:	e9 19 fa ff ff       	jmp    8010606f <alltraps>

80106656 <vector35>:
.globl vector35
vector35:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $35
80106658:	6a 23                	push   $0x23
  jmp alltraps
8010665a:	e9 10 fa ff ff       	jmp    8010606f <alltraps>

8010665f <vector36>:
.globl vector36
vector36:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $36
80106661:	6a 24                	push   $0x24
  jmp alltraps
80106663:	e9 07 fa ff ff       	jmp    8010606f <alltraps>

80106668 <vector37>:
.globl vector37
vector37:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $37
8010666a:	6a 25                	push   $0x25
  jmp alltraps
8010666c:	e9 fe f9 ff ff       	jmp    8010606f <alltraps>

80106671 <vector38>:
.globl vector38
vector38:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $38
80106673:	6a 26                	push   $0x26
  jmp alltraps
80106675:	e9 f5 f9 ff ff       	jmp    8010606f <alltraps>

8010667a <vector39>:
.globl vector39
vector39:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $39
8010667c:	6a 27                	push   $0x27
  jmp alltraps
8010667e:	e9 ec f9 ff ff       	jmp    8010606f <alltraps>

80106683 <vector40>:
.globl vector40
vector40:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $40
80106685:	6a 28                	push   $0x28
  jmp alltraps
80106687:	e9 e3 f9 ff ff       	jmp    8010606f <alltraps>

8010668c <vector41>:
.globl vector41
vector41:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $41
8010668e:	6a 29                	push   $0x29
  jmp alltraps
80106690:	e9 da f9 ff ff       	jmp    8010606f <alltraps>

80106695 <vector42>:
.globl vector42
vector42:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $42
80106697:	6a 2a                	push   $0x2a
  jmp alltraps
80106699:	e9 d1 f9 ff ff       	jmp    8010606f <alltraps>

8010669e <vector43>:
.globl vector43
vector43:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $43
801066a0:	6a 2b                	push   $0x2b
  jmp alltraps
801066a2:	e9 c8 f9 ff ff       	jmp    8010606f <alltraps>

801066a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $44
801066a9:	6a 2c                	push   $0x2c
  jmp alltraps
801066ab:	e9 bf f9 ff ff       	jmp    8010606f <alltraps>

801066b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $45
801066b2:	6a 2d                	push   $0x2d
  jmp alltraps
801066b4:	e9 b6 f9 ff ff       	jmp    8010606f <alltraps>

801066b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $46
801066bb:	6a 2e                	push   $0x2e
  jmp alltraps
801066bd:	e9 ad f9 ff ff       	jmp    8010606f <alltraps>

801066c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $47
801066c4:	6a 2f                	push   $0x2f
  jmp alltraps
801066c6:	e9 a4 f9 ff ff       	jmp    8010606f <alltraps>

801066cb <vector48>:
.globl vector48
vector48:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $48
801066cd:	6a 30                	push   $0x30
  jmp alltraps
801066cf:	e9 9b f9 ff ff       	jmp    8010606f <alltraps>

801066d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $49
801066d6:	6a 31                	push   $0x31
  jmp alltraps
801066d8:	e9 92 f9 ff ff       	jmp    8010606f <alltraps>

801066dd <vector50>:
.globl vector50
vector50:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $50
801066df:	6a 32                	push   $0x32
  jmp alltraps
801066e1:	e9 89 f9 ff ff       	jmp    8010606f <alltraps>

801066e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $51
801066e8:	6a 33                	push   $0x33
  jmp alltraps
801066ea:	e9 80 f9 ff ff       	jmp    8010606f <alltraps>

801066ef <vector52>:
.globl vector52
vector52:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $52
801066f1:	6a 34                	push   $0x34
  jmp alltraps
801066f3:	e9 77 f9 ff ff       	jmp    8010606f <alltraps>

801066f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $53
801066fa:	6a 35                	push   $0x35
  jmp alltraps
801066fc:	e9 6e f9 ff ff       	jmp    8010606f <alltraps>

80106701 <vector54>:
.globl vector54
vector54:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $54
80106703:	6a 36                	push   $0x36
  jmp alltraps
80106705:	e9 65 f9 ff ff       	jmp    8010606f <alltraps>

8010670a <vector55>:
.globl vector55
vector55:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $55
8010670c:	6a 37                	push   $0x37
  jmp alltraps
8010670e:	e9 5c f9 ff ff       	jmp    8010606f <alltraps>

80106713 <vector56>:
.globl vector56
vector56:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $56
80106715:	6a 38                	push   $0x38
  jmp alltraps
80106717:	e9 53 f9 ff ff       	jmp    8010606f <alltraps>

8010671c <vector57>:
.globl vector57
vector57:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $57
8010671e:	6a 39                	push   $0x39
  jmp alltraps
80106720:	e9 4a f9 ff ff       	jmp    8010606f <alltraps>

80106725 <vector58>:
.globl vector58
vector58:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $58
80106727:	6a 3a                	push   $0x3a
  jmp alltraps
80106729:	e9 41 f9 ff ff       	jmp    8010606f <alltraps>

8010672e <vector59>:
.globl vector59
vector59:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $59
80106730:	6a 3b                	push   $0x3b
  jmp alltraps
80106732:	e9 38 f9 ff ff       	jmp    8010606f <alltraps>

80106737 <vector60>:
.globl vector60
vector60:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $60
80106739:	6a 3c                	push   $0x3c
  jmp alltraps
8010673b:	e9 2f f9 ff ff       	jmp    8010606f <alltraps>

80106740 <vector61>:
.globl vector61
vector61:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $61
80106742:	6a 3d                	push   $0x3d
  jmp alltraps
80106744:	e9 26 f9 ff ff       	jmp    8010606f <alltraps>

80106749 <vector62>:
.globl vector62
vector62:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $62
8010674b:	6a 3e                	push   $0x3e
  jmp alltraps
8010674d:	e9 1d f9 ff ff       	jmp    8010606f <alltraps>

80106752 <vector63>:
.globl vector63
vector63:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $63
80106754:	6a 3f                	push   $0x3f
  jmp alltraps
80106756:	e9 14 f9 ff ff       	jmp    8010606f <alltraps>

8010675b <vector64>:
.globl vector64
vector64:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $64
8010675d:	6a 40                	push   $0x40
  jmp alltraps
8010675f:	e9 0b f9 ff ff       	jmp    8010606f <alltraps>

80106764 <vector65>:
.globl vector65
vector65:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $65
80106766:	6a 41                	push   $0x41
  jmp alltraps
80106768:	e9 02 f9 ff ff       	jmp    8010606f <alltraps>

8010676d <vector66>:
.globl vector66
vector66:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $66
8010676f:	6a 42                	push   $0x42
  jmp alltraps
80106771:	e9 f9 f8 ff ff       	jmp    8010606f <alltraps>

80106776 <vector67>:
.globl vector67
vector67:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $67
80106778:	6a 43                	push   $0x43
  jmp alltraps
8010677a:	e9 f0 f8 ff ff       	jmp    8010606f <alltraps>

8010677f <vector68>:
.globl vector68
vector68:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $68
80106781:	6a 44                	push   $0x44
  jmp alltraps
80106783:	e9 e7 f8 ff ff       	jmp    8010606f <alltraps>

80106788 <vector69>:
.globl vector69
vector69:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $69
8010678a:	6a 45                	push   $0x45
  jmp alltraps
8010678c:	e9 de f8 ff ff       	jmp    8010606f <alltraps>

80106791 <vector70>:
.globl vector70
vector70:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $70
80106793:	6a 46                	push   $0x46
  jmp alltraps
80106795:	e9 d5 f8 ff ff       	jmp    8010606f <alltraps>

8010679a <vector71>:
.globl vector71
vector71:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $71
8010679c:	6a 47                	push   $0x47
  jmp alltraps
8010679e:	e9 cc f8 ff ff       	jmp    8010606f <alltraps>

801067a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $72
801067a5:	6a 48                	push   $0x48
  jmp alltraps
801067a7:	e9 c3 f8 ff ff       	jmp    8010606f <alltraps>

801067ac <vector73>:
.globl vector73
vector73:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $73
801067ae:	6a 49                	push   $0x49
  jmp alltraps
801067b0:	e9 ba f8 ff ff       	jmp    8010606f <alltraps>

801067b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $74
801067b7:	6a 4a                	push   $0x4a
  jmp alltraps
801067b9:	e9 b1 f8 ff ff       	jmp    8010606f <alltraps>

801067be <vector75>:
.globl vector75
vector75:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $75
801067c0:	6a 4b                	push   $0x4b
  jmp alltraps
801067c2:	e9 a8 f8 ff ff       	jmp    8010606f <alltraps>

801067c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $76
801067c9:	6a 4c                	push   $0x4c
  jmp alltraps
801067cb:	e9 9f f8 ff ff       	jmp    8010606f <alltraps>

801067d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $77
801067d2:	6a 4d                	push   $0x4d
  jmp alltraps
801067d4:	e9 96 f8 ff ff       	jmp    8010606f <alltraps>

801067d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $78
801067db:	6a 4e                	push   $0x4e
  jmp alltraps
801067dd:	e9 8d f8 ff ff       	jmp    8010606f <alltraps>

801067e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $79
801067e4:	6a 4f                	push   $0x4f
  jmp alltraps
801067e6:	e9 84 f8 ff ff       	jmp    8010606f <alltraps>

801067eb <vector80>:
.globl vector80
vector80:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $80
801067ed:	6a 50                	push   $0x50
  jmp alltraps
801067ef:	e9 7b f8 ff ff       	jmp    8010606f <alltraps>

801067f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $81
801067f6:	6a 51                	push   $0x51
  jmp alltraps
801067f8:	e9 72 f8 ff ff       	jmp    8010606f <alltraps>

801067fd <vector82>:
.globl vector82
vector82:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $82
801067ff:	6a 52                	push   $0x52
  jmp alltraps
80106801:	e9 69 f8 ff ff       	jmp    8010606f <alltraps>

80106806 <vector83>:
.globl vector83
vector83:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $83
80106808:	6a 53                	push   $0x53
  jmp alltraps
8010680a:	e9 60 f8 ff ff       	jmp    8010606f <alltraps>

8010680f <vector84>:
.globl vector84
vector84:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $84
80106811:	6a 54                	push   $0x54
  jmp alltraps
80106813:	e9 57 f8 ff ff       	jmp    8010606f <alltraps>

80106818 <vector85>:
.globl vector85
vector85:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $85
8010681a:	6a 55                	push   $0x55
  jmp alltraps
8010681c:	e9 4e f8 ff ff       	jmp    8010606f <alltraps>

80106821 <vector86>:
.globl vector86
vector86:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $86
80106823:	6a 56                	push   $0x56
  jmp alltraps
80106825:	e9 45 f8 ff ff       	jmp    8010606f <alltraps>

8010682a <vector87>:
.globl vector87
vector87:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $87
8010682c:	6a 57                	push   $0x57
  jmp alltraps
8010682e:	e9 3c f8 ff ff       	jmp    8010606f <alltraps>

80106833 <vector88>:
.globl vector88
vector88:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $88
80106835:	6a 58                	push   $0x58
  jmp alltraps
80106837:	e9 33 f8 ff ff       	jmp    8010606f <alltraps>

8010683c <vector89>:
.globl vector89
vector89:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $89
8010683e:	6a 59                	push   $0x59
  jmp alltraps
80106840:	e9 2a f8 ff ff       	jmp    8010606f <alltraps>

80106845 <vector90>:
.globl vector90
vector90:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $90
80106847:	6a 5a                	push   $0x5a
  jmp alltraps
80106849:	e9 21 f8 ff ff       	jmp    8010606f <alltraps>

8010684e <vector91>:
.globl vector91
vector91:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $91
80106850:	6a 5b                	push   $0x5b
  jmp alltraps
80106852:	e9 18 f8 ff ff       	jmp    8010606f <alltraps>

80106857 <vector92>:
.globl vector92
vector92:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $92
80106859:	6a 5c                	push   $0x5c
  jmp alltraps
8010685b:	e9 0f f8 ff ff       	jmp    8010606f <alltraps>

80106860 <vector93>:
.globl vector93
vector93:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $93
80106862:	6a 5d                	push   $0x5d
  jmp alltraps
80106864:	e9 06 f8 ff ff       	jmp    8010606f <alltraps>

80106869 <vector94>:
.globl vector94
vector94:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $94
8010686b:	6a 5e                	push   $0x5e
  jmp alltraps
8010686d:	e9 fd f7 ff ff       	jmp    8010606f <alltraps>

80106872 <vector95>:
.globl vector95
vector95:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $95
80106874:	6a 5f                	push   $0x5f
  jmp alltraps
80106876:	e9 f4 f7 ff ff       	jmp    8010606f <alltraps>

8010687b <vector96>:
.globl vector96
vector96:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $96
8010687d:	6a 60                	push   $0x60
  jmp alltraps
8010687f:	e9 eb f7 ff ff       	jmp    8010606f <alltraps>

80106884 <vector97>:
.globl vector97
vector97:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $97
80106886:	6a 61                	push   $0x61
  jmp alltraps
80106888:	e9 e2 f7 ff ff       	jmp    8010606f <alltraps>

8010688d <vector98>:
.globl vector98
vector98:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $98
8010688f:	6a 62                	push   $0x62
  jmp alltraps
80106891:	e9 d9 f7 ff ff       	jmp    8010606f <alltraps>

80106896 <vector99>:
.globl vector99
vector99:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $99
80106898:	6a 63                	push   $0x63
  jmp alltraps
8010689a:	e9 d0 f7 ff ff       	jmp    8010606f <alltraps>

8010689f <vector100>:
.globl vector100
vector100:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $100
801068a1:	6a 64                	push   $0x64
  jmp alltraps
801068a3:	e9 c7 f7 ff ff       	jmp    8010606f <alltraps>

801068a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $101
801068aa:	6a 65                	push   $0x65
  jmp alltraps
801068ac:	e9 be f7 ff ff       	jmp    8010606f <alltraps>

801068b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $102
801068b3:	6a 66                	push   $0x66
  jmp alltraps
801068b5:	e9 b5 f7 ff ff       	jmp    8010606f <alltraps>

801068ba <vector103>:
.globl vector103
vector103:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $103
801068bc:	6a 67                	push   $0x67
  jmp alltraps
801068be:	e9 ac f7 ff ff       	jmp    8010606f <alltraps>

801068c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $104
801068c5:	6a 68                	push   $0x68
  jmp alltraps
801068c7:	e9 a3 f7 ff ff       	jmp    8010606f <alltraps>

801068cc <vector105>:
.globl vector105
vector105:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $105
801068ce:	6a 69                	push   $0x69
  jmp alltraps
801068d0:	e9 9a f7 ff ff       	jmp    8010606f <alltraps>

801068d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $106
801068d7:	6a 6a                	push   $0x6a
  jmp alltraps
801068d9:	e9 91 f7 ff ff       	jmp    8010606f <alltraps>

801068de <vector107>:
.globl vector107
vector107:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $107
801068e0:	6a 6b                	push   $0x6b
  jmp alltraps
801068e2:	e9 88 f7 ff ff       	jmp    8010606f <alltraps>

801068e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $108
801068e9:	6a 6c                	push   $0x6c
  jmp alltraps
801068eb:	e9 7f f7 ff ff       	jmp    8010606f <alltraps>

801068f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $109
801068f2:	6a 6d                	push   $0x6d
  jmp alltraps
801068f4:	e9 76 f7 ff ff       	jmp    8010606f <alltraps>

801068f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $110
801068fb:	6a 6e                	push   $0x6e
  jmp alltraps
801068fd:	e9 6d f7 ff ff       	jmp    8010606f <alltraps>

80106902 <vector111>:
.globl vector111
vector111:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $111
80106904:	6a 6f                	push   $0x6f
  jmp alltraps
80106906:	e9 64 f7 ff ff       	jmp    8010606f <alltraps>

8010690b <vector112>:
.globl vector112
vector112:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $112
8010690d:	6a 70                	push   $0x70
  jmp alltraps
8010690f:	e9 5b f7 ff ff       	jmp    8010606f <alltraps>

80106914 <vector113>:
.globl vector113
vector113:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $113
80106916:	6a 71                	push   $0x71
  jmp alltraps
80106918:	e9 52 f7 ff ff       	jmp    8010606f <alltraps>

8010691d <vector114>:
.globl vector114
vector114:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $114
8010691f:	6a 72                	push   $0x72
  jmp alltraps
80106921:	e9 49 f7 ff ff       	jmp    8010606f <alltraps>

80106926 <vector115>:
.globl vector115
vector115:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $115
80106928:	6a 73                	push   $0x73
  jmp alltraps
8010692a:	e9 40 f7 ff ff       	jmp    8010606f <alltraps>

8010692f <vector116>:
.globl vector116
vector116:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $116
80106931:	6a 74                	push   $0x74
  jmp alltraps
80106933:	e9 37 f7 ff ff       	jmp    8010606f <alltraps>

80106938 <vector117>:
.globl vector117
vector117:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $117
8010693a:	6a 75                	push   $0x75
  jmp alltraps
8010693c:	e9 2e f7 ff ff       	jmp    8010606f <alltraps>

80106941 <vector118>:
.globl vector118
vector118:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $118
80106943:	6a 76                	push   $0x76
  jmp alltraps
80106945:	e9 25 f7 ff ff       	jmp    8010606f <alltraps>

8010694a <vector119>:
.globl vector119
vector119:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $119
8010694c:	6a 77                	push   $0x77
  jmp alltraps
8010694e:	e9 1c f7 ff ff       	jmp    8010606f <alltraps>

80106953 <vector120>:
.globl vector120
vector120:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $120
80106955:	6a 78                	push   $0x78
  jmp alltraps
80106957:	e9 13 f7 ff ff       	jmp    8010606f <alltraps>

8010695c <vector121>:
.globl vector121
vector121:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $121
8010695e:	6a 79                	push   $0x79
  jmp alltraps
80106960:	e9 0a f7 ff ff       	jmp    8010606f <alltraps>

80106965 <vector122>:
.globl vector122
vector122:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $122
80106967:	6a 7a                	push   $0x7a
  jmp alltraps
80106969:	e9 01 f7 ff ff       	jmp    8010606f <alltraps>

8010696e <vector123>:
.globl vector123
vector123:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $123
80106970:	6a 7b                	push   $0x7b
  jmp alltraps
80106972:	e9 f8 f6 ff ff       	jmp    8010606f <alltraps>

80106977 <vector124>:
.globl vector124
vector124:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $124
80106979:	6a 7c                	push   $0x7c
  jmp alltraps
8010697b:	e9 ef f6 ff ff       	jmp    8010606f <alltraps>

80106980 <vector125>:
.globl vector125
vector125:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $125
80106982:	6a 7d                	push   $0x7d
  jmp alltraps
80106984:	e9 e6 f6 ff ff       	jmp    8010606f <alltraps>

80106989 <vector126>:
.globl vector126
vector126:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $126
8010698b:	6a 7e                	push   $0x7e
  jmp alltraps
8010698d:	e9 dd f6 ff ff       	jmp    8010606f <alltraps>

80106992 <vector127>:
.globl vector127
vector127:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $127
80106994:	6a 7f                	push   $0x7f
  jmp alltraps
80106996:	e9 d4 f6 ff ff       	jmp    8010606f <alltraps>

8010699b <vector128>:
.globl vector128
vector128:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $128
8010699d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069a2:	e9 c8 f6 ff ff       	jmp    8010606f <alltraps>

801069a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $129
801069a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ae:	e9 bc f6 ff ff       	jmp    8010606f <alltraps>

801069b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $130
801069b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069ba:	e9 b0 f6 ff ff       	jmp    8010606f <alltraps>

801069bf <vector131>:
.globl vector131
vector131:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $131
801069c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801069c6:	e9 a4 f6 ff ff       	jmp    8010606f <alltraps>

801069cb <vector132>:
.globl vector132
vector132:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $132
801069cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801069d2:	e9 98 f6 ff ff       	jmp    8010606f <alltraps>

801069d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $133
801069d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069de:	e9 8c f6 ff ff       	jmp    8010606f <alltraps>

801069e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $134
801069e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801069ea:	e9 80 f6 ff ff       	jmp    8010606f <alltraps>

801069ef <vector135>:
.globl vector135
vector135:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $135
801069f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069f6:	e9 74 f6 ff ff       	jmp    8010606f <alltraps>

801069fb <vector136>:
.globl vector136
vector136:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $136
801069fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a02:	e9 68 f6 ff ff       	jmp    8010606f <alltraps>

80106a07 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $137
80106a09:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a0e:	e9 5c f6 ff ff       	jmp    8010606f <alltraps>

80106a13 <vector138>:
.globl vector138
vector138:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $138
80106a15:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a1a:	e9 50 f6 ff ff       	jmp    8010606f <alltraps>

80106a1f <vector139>:
.globl vector139
vector139:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $139
80106a21:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a26:	e9 44 f6 ff ff       	jmp    8010606f <alltraps>

80106a2b <vector140>:
.globl vector140
vector140:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $140
80106a2d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a32:	e9 38 f6 ff ff       	jmp    8010606f <alltraps>

80106a37 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $141
80106a39:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a3e:	e9 2c f6 ff ff       	jmp    8010606f <alltraps>

80106a43 <vector142>:
.globl vector142
vector142:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $142
80106a45:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a4a:	e9 20 f6 ff ff       	jmp    8010606f <alltraps>

80106a4f <vector143>:
.globl vector143
vector143:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $143
80106a51:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a56:	e9 14 f6 ff ff       	jmp    8010606f <alltraps>

80106a5b <vector144>:
.globl vector144
vector144:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $144
80106a5d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a62:	e9 08 f6 ff ff       	jmp    8010606f <alltraps>

80106a67 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $145
80106a69:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a6e:	e9 fc f5 ff ff       	jmp    8010606f <alltraps>

80106a73 <vector146>:
.globl vector146
vector146:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $146
80106a75:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a7a:	e9 f0 f5 ff ff       	jmp    8010606f <alltraps>

80106a7f <vector147>:
.globl vector147
vector147:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $147
80106a81:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a86:	e9 e4 f5 ff ff       	jmp    8010606f <alltraps>

80106a8b <vector148>:
.globl vector148
vector148:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $148
80106a8d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a92:	e9 d8 f5 ff ff       	jmp    8010606f <alltraps>

80106a97 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $149
80106a99:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a9e:	e9 cc f5 ff ff       	jmp    8010606f <alltraps>

80106aa3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $150
80106aa5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106aaa:	e9 c0 f5 ff ff       	jmp    8010606f <alltraps>

80106aaf <vector151>:
.globl vector151
vector151:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $151
80106ab1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ab6:	e9 b4 f5 ff ff       	jmp    8010606f <alltraps>

80106abb <vector152>:
.globl vector152
vector152:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $152
80106abd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ac2:	e9 a8 f5 ff ff       	jmp    8010606f <alltraps>

80106ac7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $153
80106ac9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106ace:	e9 9c f5 ff ff       	jmp    8010606f <alltraps>

80106ad3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $154
80106ad5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ada:	e9 90 f5 ff ff       	jmp    8010606f <alltraps>

80106adf <vector155>:
.globl vector155
vector155:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $155
80106ae1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ae6:	e9 84 f5 ff ff       	jmp    8010606f <alltraps>

80106aeb <vector156>:
.globl vector156
vector156:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $156
80106aed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106af2:	e9 78 f5 ff ff       	jmp    8010606f <alltraps>

80106af7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $157
80106af9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106afe:	e9 6c f5 ff ff       	jmp    8010606f <alltraps>

80106b03 <vector158>:
.globl vector158
vector158:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $158
80106b05:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b0a:	e9 60 f5 ff ff       	jmp    8010606f <alltraps>

80106b0f <vector159>:
.globl vector159
vector159:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $159
80106b11:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b16:	e9 54 f5 ff ff       	jmp    8010606f <alltraps>

80106b1b <vector160>:
.globl vector160
vector160:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $160
80106b1d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b22:	e9 48 f5 ff ff       	jmp    8010606f <alltraps>

80106b27 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $161
80106b29:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b2e:	e9 3c f5 ff ff       	jmp    8010606f <alltraps>

80106b33 <vector162>:
.globl vector162
vector162:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $162
80106b35:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b3a:	e9 30 f5 ff ff       	jmp    8010606f <alltraps>

80106b3f <vector163>:
.globl vector163
vector163:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $163
80106b41:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b46:	e9 24 f5 ff ff       	jmp    8010606f <alltraps>

80106b4b <vector164>:
.globl vector164
vector164:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $164
80106b4d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b52:	e9 18 f5 ff ff       	jmp    8010606f <alltraps>

80106b57 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $165
80106b59:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b5e:	e9 0c f5 ff ff       	jmp    8010606f <alltraps>

80106b63 <vector166>:
.globl vector166
vector166:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $166
80106b65:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b6a:	e9 00 f5 ff ff       	jmp    8010606f <alltraps>

80106b6f <vector167>:
.globl vector167
vector167:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $167
80106b71:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b76:	e9 f4 f4 ff ff       	jmp    8010606f <alltraps>

80106b7b <vector168>:
.globl vector168
vector168:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $168
80106b7d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b82:	e9 e8 f4 ff ff       	jmp    8010606f <alltraps>

80106b87 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $169
80106b89:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b8e:	e9 dc f4 ff ff       	jmp    8010606f <alltraps>

80106b93 <vector170>:
.globl vector170
vector170:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $170
80106b95:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b9a:	e9 d0 f4 ff ff       	jmp    8010606f <alltraps>

80106b9f <vector171>:
.globl vector171
vector171:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $171
80106ba1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ba6:	e9 c4 f4 ff ff       	jmp    8010606f <alltraps>

80106bab <vector172>:
.globl vector172
vector172:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $172
80106bad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bb2:	e9 b8 f4 ff ff       	jmp    8010606f <alltraps>

80106bb7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $173
80106bb9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bbe:	e9 ac f4 ff ff       	jmp    8010606f <alltraps>

80106bc3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $174
80106bc5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106bca:	e9 a0 f4 ff ff       	jmp    8010606f <alltraps>

80106bcf <vector175>:
.globl vector175
vector175:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $175
80106bd1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106bd6:	e9 94 f4 ff ff       	jmp    8010606f <alltraps>

80106bdb <vector176>:
.globl vector176
vector176:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $176
80106bdd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106be2:	e9 88 f4 ff ff       	jmp    8010606f <alltraps>

80106be7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $177
80106be9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106bee:	e9 7c f4 ff ff       	jmp    8010606f <alltraps>

80106bf3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $178
80106bf5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106bfa:	e9 70 f4 ff ff       	jmp    8010606f <alltraps>

80106bff <vector179>:
.globl vector179
vector179:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $179
80106c01:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c06:	e9 64 f4 ff ff       	jmp    8010606f <alltraps>

80106c0b <vector180>:
.globl vector180
vector180:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $180
80106c0d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c12:	e9 58 f4 ff ff       	jmp    8010606f <alltraps>

80106c17 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $181
80106c19:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c1e:	e9 4c f4 ff ff       	jmp    8010606f <alltraps>

80106c23 <vector182>:
.globl vector182
vector182:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $182
80106c25:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c2a:	e9 40 f4 ff ff       	jmp    8010606f <alltraps>

80106c2f <vector183>:
.globl vector183
vector183:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $183
80106c31:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c36:	e9 34 f4 ff ff       	jmp    8010606f <alltraps>

80106c3b <vector184>:
.globl vector184
vector184:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $184
80106c3d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c42:	e9 28 f4 ff ff       	jmp    8010606f <alltraps>

80106c47 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $185
80106c49:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c4e:	e9 1c f4 ff ff       	jmp    8010606f <alltraps>

80106c53 <vector186>:
.globl vector186
vector186:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $186
80106c55:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c5a:	e9 10 f4 ff ff       	jmp    8010606f <alltraps>

80106c5f <vector187>:
.globl vector187
vector187:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $187
80106c61:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c66:	e9 04 f4 ff ff       	jmp    8010606f <alltraps>

80106c6b <vector188>:
.globl vector188
vector188:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $188
80106c6d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c72:	e9 f8 f3 ff ff       	jmp    8010606f <alltraps>

80106c77 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $189
80106c79:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c7e:	e9 ec f3 ff ff       	jmp    8010606f <alltraps>

80106c83 <vector190>:
.globl vector190
vector190:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $190
80106c85:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c8a:	e9 e0 f3 ff ff       	jmp    8010606f <alltraps>

80106c8f <vector191>:
.globl vector191
vector191:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $191
80106c91:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c96:	e9 d4 f3 ff ff       	jmp    8010606f <alltraps>

80106c9b <vector192>:
.globl vector192
vector192:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $192
80106c9d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ca2:	e9 c8 f3 ff ff       	jmp    8010606f <alltraps>

80106ca7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $193
80106ca9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cae:	e9 bc f3 ff ff       	jmp    8010606f <alltraps>

80106cb3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $194
80106cb5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cba:	e9 b0 f3 ff ff       	jmp    8010606f <alltraps>

80106cbf <vector195>:
.globl vector195
vector195:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $195
80106cc1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106cc6:	e9 a4 f3 ff ff       	jmp    8010606f <alltraps>

80106ccb <vector196>:
.globl vector196
vector196:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $196
80106ccd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106cd2:	e9 98 f3 ff ff       	jmp    8010606f <alltraps>

80106cd7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $197
80106cd9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106cde:	e9 8c f3 ff ff       	jmp    8010606f <alltraps>

80106ce3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $198
80106ce5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106cea:	e9 80 f3 ff ff       	jmp    8010606f <alltraps>

80106cef <vector199>:
.globl vector199
vector199:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $199
80106cf1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106cf6:	e9 74 f3 ff ff       	jmp    8010606f <alltraps>

80106cfb <vector200>:
.globl vector200
vector200:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $200
80106cfd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d02:	e9 68 f3 ff ff       	jmp    8010606f <alltraps>

80106d07 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $201
80106d09:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d0e:	e9 5c f3 ff ff       	jmp    8010606f <alltraps>

80106d13 <vector202>:
.globl vector202
vector202:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $202
80106d15:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d1a:	e9 50 f3 ff ff       	jmp    8010606f <alltraps>

80106d1f <vector203>:
.globl vector203
vector203:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $203
80106d21:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d26:	e9 44 f3 ff ff       	jmp    8010606f <alltraps>

80106d2b <vector204>:
.globl vector204
vector204:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $204
80106d2d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d32:	e9 38 f3 ff ff       	jmp    8010606f <alltraps>

80106d37 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $205
80106d39:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d3e:	e9 2c f3 ff ff       	jmp    8010606f <alltraps>

80106d43 <vector206>:
.globl vector206
vector206:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $206
80106d45:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d4a:	e9 20 f3 ff ff       	jmp    8010606f <alltraps>

80106d4f <vector207>:
.globl vector207
vector207:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $207
80106d51:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d56:	e9 14 f3 ff ff       	jmp    8010606f <alltraps>

80106d5b <vector208>:
.globl vector208
vector208:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $208
80106d5d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d62:	e9 08 f3 ff ff       	jmp    8010606f <alltraps>

80106d67 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $209
80106d69:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d6e:	e9 fc f2 ff ff       	jmp    8010606f <alltraps>

80106d73 <vector210>:
.globl vector210
vector210:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $210
80106d75:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d7a:	e9 f0 f2 ff ff       	jmp    8010606f <alltraps>

80106d7f <vector211>:
.globl vector211
vector211:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $211
80106d81:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d86:	e9 e4 f2 ff ff       	jmp    8010606f <alltraps>

80106d8b <vector212>:
.globl vector212
vector212:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $212
80106d8d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d92:	e9 d8 f2 ff ff       	jmp    8010606f <alltraps>

80106d97 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $213
80106d99:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d9e:	e9 cc f2 ff ff       	jmp    8010606f <alltraps>

80106da3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $214
80106da5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106daa:	e9 c0 f2 ff ff       	jmp    8010606f <alltraps>

80106daf <vector215>:
.globl vector215
vector215:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $215
80106db1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106db6:	e9 b4 f2 ff ff       	jmp    8010606f <alltraps>

80106dbb <vector216>:
.globl vector216
vector216:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $216
80106dbd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dc2:	e9 a8 f2 ff ff       	jmp    8010606f <alltraps>

80106dc7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $217
80106dc9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106dce:	e9 9c f2 ff ff       	jmp    8010606f <alltraps>

80106dd3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $218
80106dd5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106dda:	e9 90 f2 ff ff       	jmp    8010606f <alltraps>

80106ddf <vector219>:
.globl vector219
vector219:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $219
80106de1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106de6:	e9 84 f2 ff ff       	jmp    8010606f <alltraps>

80106deb <vector220>:
.globl vector220
vector220:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $220
80106ded:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106df2:	e9 78 f2 ff ff       	jmp    8010606f <alltraps>

80106df7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $221
80106df9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106dfe:	e9 6c f2 ff ff       	jmp    8010606f <alltraps>

80106e03 <vector222>:
.globl vector222
vector222:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $222
80106e05:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e0a:	e9 60 f2 ff ff       	jmp    8010606f <alltraps>

80106e0f <vector223>:
.globl vector223
vector223:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $223
80106e11:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e16:	e9 54 f2 ff ff       	jmp    8010606f <alltraps>

80106e1b <vector224>:
.globl vector224
vector224:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $224
80106e1d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e22:	e9 48 f2 ff ff       	jmp    8010606f <alltraps>

80106e27 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $225
80106e29:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e2e:	e9 3c f2 ff ff       	jmp    8010606f <alltraps>

80106e33 <vector226>:
.globl vector226
vector226:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $226
80106e35:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e3a:	e9 30 f2 ff ff       	jmp    8010606f <alltraps>

80106e3f <vector227>:
.globl vector227
vector227:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $227
80106e41:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e46:	e9 24 f2 ff ff       	jmp    8010606f <alltraps>

80106e4b <vector228>:
.globl vector228
vector228:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $228
80106e4d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e52:	e9 18 f2 ff ff       	jmp    8010606f <alltraps>

80106e57 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $229
80106e59:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e5e:	e9 0c f2 ff ff       	jmp    8010606f <alltraps>

80106e63 <vector230>:
.globl vector230
vector230:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $230
80106e65:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e6a:	e9 00 f2 ff ff       	jmp    8010606f <alltraps>

80106e6f <vector231>:
.globl vector231
vector231:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $231
80106e71:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e76:	e9 f4 f1 ff ff       	jmp    8010606f <alltraps>

80106e7b <vector232>:
.globl vector232
vector232:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $232
80106e7d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e82:	e9 e8 f1 ff ff       	jmp    8010606f <alltraps>

80106e87 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $233
80106e89:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e8e:	e9 dc f1 ff ff       	jmp    8010606f <alltraps>

80106e93 <vector234>:
.globl vector234
vector234:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $234
80106e95:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e9a:	e9 d0 f1 ff ff       	jmp    8010606f <alltraps>

80106e9f <vector235>:
.globl vector235
vector235:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $235
80106ea1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ea6:	e9 c4 f1 ff ff       	jmp    8010606f <alltraps>

80106eab <vector236>:
.globl vector236
vector236:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $236
80106ead:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106eb2:	e9 b8 f1 ff ff       	jmp    8010606f <alltraps>

80106eb7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $237
80106eb9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ebe:	e9 ac f1 ff ff       	jmp    8010606f <alltraps>

80106ec3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $238
80106ec5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106eca:	e9 a0 f1 ff ff       	jmp    8010606f <alltraps>

80106ecf <vector239>:
.globl vector239
vector239:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $239
80106ed1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ed6:	e9 94 f1 ff ff       	jmp    8010606f <alltraps>

80106edb <vector240>:
.globl vector240
vector240:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $240
80106edd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ee2:	e9 88 f1 ff ff       	jmp    8010606f <alltraps>

80106ee7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $241
80106ee9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106eee:	e9 7c f1 ff ff       	jmp    8010606f <alltraps>

80106ef3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $242
80106ef5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106efa:	e9 70 f1 ff ff       	jmp    8010606f <alltraps>

80106eff <vector243>:
.globl vector243
vector243:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $243
80106f01:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f06:	e9 64 f1 ff ff       	jmp    8010606f <alltraps>

80106f0b <vector244>:
.globl vector244
vector244:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $244
80106f0d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f12:	e9 58 f1 ff ff       	jmp    8010606f <alltraps>

80106f17 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $245
80106f19:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f1e:	e9 4c f1 ff ff       	jmp    8010606f <alltraps>

80106f23 <vector246>:
.globl vector246
vector246:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $246
80106f25:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f2a:	e9 40 f1 ff ff       	jmp    8010606f <alltraps>

80106f2f <vector247>:
.globl vector247
vector247:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $247
80106f31:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f36:	e9 34 f1 ff ff       	jmp    8010606f <alltraps>

80106f3b <vector248>:
.globl vector248
vector248:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $248
80106f3d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f42:	e9 28 f1 ff ff       	jmp    8010606f <alltraps>

80106f47 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $249
80106f49:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f4e:	e9 1c f1 ff ff       	jmp    8010606f <alltraps>

80106f53 <vector250>:
.globl vector250
vector250:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $250
80106f55:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f5a:	e9 10 f1 ff ff       	jmp    8010606f <alltraps>

80106f5f <vector251>:
.globl vector251
vector251:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $251
80106f61:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f66:	e9 04 f1 ff ff       	jmp    8010606f <alltraps>

80106f6b <vector252>:
.globl vector252
vector252:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $252
80106f6d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f72:	e9 f8 f0 ff ff       	jmp    8010606f <alltraps>

80106f77 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $253
80106f79:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f7e:	e9 ec f0 ff ff       	jmp    8010606f <alltraps>

80106f83 <vector254>:
.globl vector254
vector254:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $254
80106f85:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f8a:	e9 e0 f0 ff ff       	jmp    8010606f <alltraps>

80106f8f <vector255>:
.globl vector255
vector255:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $255
80106f91:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f96:	e9 d4 f0 ff ff       	jmp    8010606f <alltraps>
80106f9b:	66 90                	xchg   %ax,%ax
80106f9d:	66 90                	xchg   %ax,%ax
80106f9f:	90                   	nop

80106fa0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106fa7:	c1 ea 16             	shr    $0x16,%edx
{
80106faa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106fab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106fae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106fb1:	8b 1f                	mov    (%edi),%ebx
80106fb3:	f6 c3 01             	test   $0x1,%bl
80106fb6:	74 28                	je     80106fe0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106fbe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106fc4:	89 f0                	mov    %esi,%eax
}
80106fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106fc9:	c1 e8 0a             	shr    $0xa,%eax
80106fcc:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fd1:	01 d8                	add    %ebx,%eax
}
80106fd3:	5b                   	pop    %ebx
80106fd4:	5e                   	pop    %esi
80106fd5:	5f                   	pop    %edi
80106fd6:	5d                   	pop    %ebp
80106fd7:	c3                   	ret    
80106fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fe0:	85 c9                	test   %ecx,%ecx
80106fe2:	74 2c                	je     80107010 <walkpgdir+0x70>
80106fe4:	e8 57 b6 ff ff       	call   80102640 <kalloc>
80106fe9:	89 c3                	mov    %eax,%ebx
80106feb:	85 c0                	test   %eax,%eax
80106fed:	74 21                	je     80107010 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106fef:	83 ec 04             	sub    $0x4,%esp
80106ff2:	68 00 10 00 00       	push   $0x1000
80106ff7:	6a 00                	push   $0x0
80106ff9:	50                   	push   %eax
80106ffa:	e8 51 dd ff ff       	call   80104d50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107005:	83 c4 10             	add    $0x10,%esp
80107008:	83 c8 07             	or     $0x7,%eax
8010700b:	89 07                	mov    %eax,(%edi)
8010700d:	eb b5                	jmp    80106fc4 <walkpgdir+0x24>
8010700f:	90                   	nop
}
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107013:	31 c0                	xor    %eax,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107020 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107026:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010702a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010702b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107030:	89 d6                	mov    %edx,%esi
{
80107032:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107033:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107039:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010703c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010703f:	8b 45 08             	mov    0x8(%ebp),%eax
80107042:	29 f0                	sub    %esi,%eax
80107044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107047:	eb 1f                	jmp    80107068 <mappages+0x48>
80107049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107050:	f6 00 01             	testb  $0x1,(%eax)
80107053:	75 45                	jne    8010709a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107055:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107058:	83 cb 01             	or     $0x1,%ebx
8010705b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010705d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107060:	74 2e                	je     80107090 <mappages+0x70>
      break;
    a += PGSIZE;
80107062:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010706b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107070:	89 f2                	mov    %esi,%edx
80107072:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107075:	89 f8                	mov    %edi,%eax
80107077:	e8 24 ff ff ff       	call   80106fa0 <walkpgdir>
8010707c:	85 c0                	test   %eax,%eax
8010707e:	75 d0                	jne    80107050 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107080:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107088:	5b                   	pop    %ebx
80107089:	5e                   	pop    %esi
8010708a:	5f                   	pop    %edi
8010708b:	5d                   	pop    %ebp
8010708c:	c3                   	ret    
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
80107090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107093:	31 c0                	xor    %eax,%eax
}
80107095:	5b                   	pop    %ebx
80107096:	5e                   	pop    %esi
80107097:	5f                   	pop    %edi
80107098:	5d                   	pop    %ebp
80107099:	c3                   	ret    
      panic("remap");
8010709a:	83 ec 0c             	sub    $0xc,%esp
8010709d:	68 70 82 10 80       	push   $0x80108270
801070a2:	e8 e9 92 ff ff       	call   80100390 <panic>
801070a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	89 c6                	mov    %eax,%esi
801070b7:	53                   	push   %ebx
801070b8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070ba:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801070c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070cc:	39 da                	cmp    %ebx,%edx
801070ce:	73 5b                	jae    8010712b <deallocuvm.part.0+0x7b>
801070d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801070d3:	89 d7                	mov    %edx,%edi
801070d5:	eb 14                	jmp    801070eb <deallocuvm.part.0+0x3b>
801070d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070de:	66 90                	xchg   %ax,%ax
801070e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070e6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801070e9:	76 40                	jbe    8010712b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801070eb:	31 c9                	xor    %ecx,%ecx
801070ed:	89 fa                	mov    %edi,%edx
801070ef:	89 f0                	mov    %esi,%eax
801070f1:	e8 aa fe ff ff       	call   80106fa0 <walkpgdir>
801070f6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801070f8:	85 c0                	test   %eax,%eax
801070fa:	74 44                	je     80107140 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801070fc:	8b 00                	mov    (%eax),%eax
801070fe:	a8 01                	test   $0x1,%al
80107100:	74 de                	je     801070e0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107107:	74 47                	je     80107150 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107109:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010710c:	05 00 00 00 80       	add    $0x80000000,%eax
80107111:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107117:	50                   	push   %eax
80107118:	e8 63 b3 ff ff       	call   80102480 <kfree>
      *pte = 0;
8010711d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107123:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107126:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107129:	77 c0                	ja     801070eb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010712b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010712e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107131:	5b                   	pop    %ebx
80107132:	5e                   	pop    %esi
80107133:	5f                   	pop    %edi
80107134:	5d                   	pop    %ebp
80107135:	c3                   	ret    
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107140:	89 fa                	mov    %edi,%edx
80107142:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107148:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010714e:	eb 96                	jmp    801070e6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	68 46 7b 10 80       	push   $0x80107b46
80107158:	e8 33 92 ff ff       	call   80100390 <panic>
8010715d:	8d 76 00             	lea    0x0(%esi),%esi

80107160 <seginit>:
{
80107160:	f3 0f 1e fb          	endbr32 
80107164:	55                   	push   %ebp
80107165:	89 e5                	mov    %esp,%ebp
80107167:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010716a:	e8 51 ca ff ff       	call   80103bc0 <cpuid>
  pd[0] = size-1;
8010716f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107174:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010717a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010717e:	c7 80 f8 7c 11 80 ff 	movl   $0xffff,-0x7fee8308(%eax)
80107185:	ff 00 00 
80107188:	c7 80 fc 7c 11 80 00 	movl   $0xcf9a00,-0x7fee8304(%eax)
8010718f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107192:	c7 80 00 7d 11 80 ff 	movl   $0xffff,-0x7fee8300(%eax)
80107199:	ff 00 00 
8010719c:	c7 80 04 7d 11 80 00 	movl   $0xcf9200,-0x7fee82fc(%eax)
801071a3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071a6:	c7 80 08 7d 11 80 ff 	movl   $0xffff,-0x7fee82f8(%eax)
801071ad:	ff 00 00 
801071b0:	c7 80 0c 7d 11 80 00 	movl   $0xcffa00,-0x7fee82f4(%eax)
801071b7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071ba:	c7 80 10 7d 11 80 ff 	movl   $0xffff,-0x7fee82f0(%eax)
801071c1:	ff 00 00 
801071c4:	c7 80 14 7d 11 80 00 	movl   $0xcff200,-0x7fee82ec(%eax)
801071cb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071ce:	05 f0 7c 11 80       	add    $0x80117cf0,%eax
  pd[1] = (uint)p;
801071d3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071d7:	c1 e8 10             	shr    $0x10,%eax
801071da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071de:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071e1:	0f 01 10             	lgdtl  (%eax)
}
801071e4:	c9                   	leave  
801071e5:	c3                   	ret    
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <switchkvm>:
{
801071f0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071f4:	a1 c4 ae 11 80       	mov    0x8011aec4,%eax
801071f9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071fe:	0f 22 d8             	mov    %eax,%cr3
}
80107201:	c3                   	ret    
80107202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <switchuvm>:
{
80107210:	f3 0f 1e fb          	endbr32 
80107214:	55                   	push   %ebp
80107215:	89 e5                	mov    %esp,%ebp
80107217:	57                   	push   %edi
80107218:	56                   	push   %esi
80107219:	53                   	push   %ebx
8010721a:	83 ec 1c             	sub    $0x1c,%esp
8010721d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107220:	85 f6                	test   %esi,%esi
80107222:	0f 84 cb 00 00 00    	je     801072f3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107228:	8b 46 1c             	mov    0x1c(%esi),%eax
8010722b:	85 c0                	test   %eax,%eax
8010722d:	0f 84 da 00 00 00    	je     8010730d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107233:	8b 46 18             	mov    0x18(%esi),%eax
80107236:	85 c0                	test   %eax,%eax
80107238:	0f 84 c2 00 00 00    	je     80107300 <switchuvm+0xf0>
  pushcli();
8010723e:	e8 fd d8 ff ff       	call   80104b40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107243:	e8 08 c9 ff ff       	call   80103b50 <mycpu>
80107248:	89 c3                	mov    %eax,%ebx
8010724a:	e8 01 c9 ff ff       	call   80103b50 <mycpu>
8010724f:	89 c7                	mov    %eax,%edi
80107251:	e8 fa c8 ff ff       	call   80103b50 <mycpu>
80107256:	83 c7 08             	add    $0x8,%edi
80107259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010725c:	e8 ef c8 ff ff       	call   80103b50 <mycpu>
80107261:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107264:	ba 67 00 00 00       	mov    $0x67,%edx
80107269:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107270:	83 c0 08             	add    $0x8,%eax
80107273:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010727a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010727f:	83 c1 08             	add    $0x8,%ecx
80107282:	c1 e8 18             	shr    $0x18,%eax
80107285:	c1 e9 10             	shr    $0x10,%ecx
80107288:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010728e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107294:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107299:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072a5:	e8 a6 c8 ff ff       	call   80103b50 <mycpu>
801072aa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072b1:	e8 9a c8 ff ff       	call   80103b50 <mycpu>
801072b6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072ba:	8b 5e 1c             	mov    0x1c(%esi),%ebx
801072bd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072c3:	e8 88 c8 ff ff       	call   80103b50 <mycpu>
801072c8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072cb:	e8 80 c8 ff ff       	call   80103b50 <mycpu>
801072d0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072d4:	b8 28 00 00 00       	mov    $0x28,%eax
801072d9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072dc:	8b 46 18             	mov    0x18(%esi),%eax
801072df:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072e4:	0f 22 d8             	mov    %eax,%cr3
}
801072e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ea:	5b                   	pop    %ebx
801072eb:	5e                   	pop    %esi
801072ec:	5f                   	pop    %edi
801072ed:	5d                   	pop    %ebp
  popcli();
801072ee:	e9 9d d8 ff ff       	jmp    80104b90 <popcli>
    panic("switchuvm: no process");
801072f3:	83 ec 0c             	sub    $0xc,%esp
801072f6:	68 76 82 10 80       	push   $0x80108276
801072fb:	e8 90 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107300:	83 ec 0c             	sub    $0xc,%esp
80107303:	68 a1 82 10 80       	push   $0x801082a1
80107308:	e8 83 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010730d:	83 ec 0c             	sub    $0xc,%esp
80107310:	68 8c 82 10 80       	push   $0x8010828c
80107315:	e8 76 90 ff ff       	call   80100390 <panic>
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <inituvm>:
{
80107320:	f3 0f 1e fb          	endbr32 
80107324:	55                   	push   %ebp
80107325:	89 e5                	mov    %esp,%ebp
80107327:	57                   	push   %edi
80107328:	56                   	push   %esi
80107329:	53                   	push   %ebx
8010732a:	83 ec 1c             	sub    $0x1c,%esp
8010732d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107330:	8b 75 10             	mov    0x10(%ebp),%esi
80107333:	8b 7d 08             	mov    0x8(%ebp),%edi
80107336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107339:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010733f:	77 4b                	ja     8010738c <inituvm+0x6c>
  mem = kalloc();
80107341:	e8 fa b2 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80107346:	83 ec 04             	sub    $0x4,%esp
80107349:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010734e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107350:	6a 00                	push   $0x0
80107352:	50                   	push   %eax
80107353:	e8 f8 d9 ff ff       	call   80104d50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107358:	58                   	pop    %eax
80107359:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010735f:	5a                   	pop    %edx
80107360:	6a 06                	push   $0x6
80107362:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107367:	31 d2                	xor    %edx,%edx
80107369:	50                   	push   %eax
8010736a:	89 f8                	mov    %edi,%eax
8010736c:	e8 af fc ff ff       	call   80107020 <mappages>
  memmove(mem, init, sz);
80107371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107374:	89 75 10             	mov    %esi,0x10(%ebp)
80107377:	83 c4 10             	add    $0x10,%esp
8010737a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010737d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107380:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107383:	5b                   	pop    %ebx
80107384:	5e                   	pop    %esi
80107385:	5f                   	pop    %edi
80107386:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107387:	e9 64 da ff ff       	jmp    80104df0 <memmove>
    panic("inituvm: more than a page");
8010738c:	83 ec 0c             	sub    $0xc,%esp
8010738f:	68 b5 82 10 80       	push   $0x801082b5
80107394:	e8 f7 8f ff ff       	call   80100390 <panic>
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073a0 <loaduvm>:
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	57                   	push   %edi
801073a8:	56                   	push   %esi
801073a9:	53                   	push   %ebx
801073aa:	83 ec 1c             	sub    $0x1c,%esp
801073ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801073b0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801073b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073b8:	0f 85 99 00 00 00    	jne    80107457 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801073be:	01 f0                	add    %esi,%eax
801073c0:	89 f3                	mov    %esi,%ebx
801073c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073c5:	8b 45 14             	mov    0x14(%ebp),%eax
801073c8:	01 f0                	add    %esi,%eax
801073ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801073cd:	85 f6                	test   %esi,%esi
801073cf:	75 15                	jne    801073e6 <loaduvm+0x46>
801073d1:	eb 6d                	jmp    80107440 <loaduvm+0xa0>
801073d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073d7:	90                   	nop
801073d8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801073de:	89 f0                	mov    %esi,%eax
801073e0:	29 d8                	sub    %ebx,%eax
801073e2:	39 c6                	cmp    %eax,%esi
801073e4:	76 5a                	jbe    80107440 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801073e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073e9:	8b 45 08             	mov    0x8(%ebp),%eax
801073ec:	31 c9                	xor    %ecx,%ecx
801073ee:	29 da                	sub    %ebx,%edx
801073f0:	e8 ab fb ff ff       	call   80106fa0 <walkpgdir>
801073f5:	85 c0                	test   %eax,%eax
801073f7:	74 51                	je     8010744a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801073f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801073fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107403:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107408:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010740e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107411:	29 d9                	sub    %ebx,%ecx
80107413:	05 00 00 00 80       	add    $0x80000000,%eax
80107418:	57                   	push   %edi
80107419:	51                   	push   %ecx
8010741a:	50                   	push   %eax
8010741b:	ff 75 10             	pushl  0x10(%ebp)
8010741e:	e8 4d a6 ff ff       	call   80101a70 <readi>
80107423:	83 c4 10             	add    $0x10,%esp
80107426:	39 f8                	cmp    %edi,%eax
80107428:	74 ae                	je     801073d8 <loaduvm+0x38>
}
8010742a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010742d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107432:	5b                   	pop    %ebx
80107433:	5e                   	pop    %esi
80107434:	5f                   	pop    %edi
80107435:	5d                   	pop    %ebp
80107436:	c3                   	ret    
80107437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743e:	66 90                	xchg   %ax,%ax
80107440:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107443:	31 c0                	xor    %eax,%eax
}
80107445:	5b                   	pop    %ebx
80107446:	5e                   	pop    %esi
80107447:	5f                   	pop    %edi
80107448:	5d                   	pop    %ebp
80107449:	c3                   	ret    
      panic("loaduvm: address should exist");
8010744a:	83 ec 0c             	sub    $0xc,%esp
8010744d:	68 cf 82 10 80       	push   $0x801082cf
80107452:	e8 39 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107457:	83 ec 0c             	sub    $0xc,%esp
8010745a:	68 70 83 10 80       	push   $0x80108370
8010745f:	e8 2c 8f ff ff       	call   80100390 <panic>
80107464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop

80107470 <allocuvm>:
{
80107470:	f3 0f 1e fb          	endbr32 
80107474:	55                   	push   %ebp
80107475:	89 e5                	mov    %esp,%ebp
80107477:	57                   	push   %edi
80107478:	56                   	push   %esi
80107479:	53                   	push   %ebx
8010747a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010747d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107480:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107483:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107486:	85 c0                	test   %eax,%eax
80107488:	0f 88 b2 00 00 00    	js     80107540 <allocuvm+0xd0>
  if(newsz < oldsz)
8010748e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107491:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107494:	0f 82 96 00 00 00    	jb     80107530 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010749a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801074a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801074a9:	77 40                	ja     801074eb <allocuvm+0x7b>
801074ab:	e9 83 00 00 00       	jmp    80107533 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801074b0:	83 ec 04             	sub    $0x4,%esp
801074b3:	68 00 10 00 00       	push   $0x1000
801074b8:	6a 00                	push   $0x0
801074ba:	50                   	push   %eax
801074bb:	e8 90 d8 ff ff       	call   80104d50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074c0:	58                   	pop    %eax
801074c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074c7:	5a                   	pop    %edx
801074c8:	6a 06                	push   $0x6
801074ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074cf:	89 f2                	mov    %esi,%edx
801074d1:	50                   	push   %eax
801074d2:	89 f8                	mov    %edi,%eax
801074d4:	e8 47 fb ff ff       	call   80107020 <mappages>
801074d9:	83 c4 10             	add    $0x10,%esp
801074dc:	85 c0                	test   %eax,%eax
801074de:	78 78                	js     80107558 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801074e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801074e9:	76 48                	jbe    80107533 <allocuvm+0xc3>
    mem = kalloc();
801074eb:	e8 50 b1 ff ff       	call   80102640 <kalloc>
801074f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801074f2:	85 c0                	test   %eax,%eax
801074f4:	75 ba                	jne    801074b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801074f6:	83 ec 0c             	sub    $0xc,%esp
801074f9:	68 ed 82 10 80       	push   $0x801082ed
801074fe:	e8 ad 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107503:	8b 45 0c             	mov    0xc(%ebp),%eax
80107506:	83 c4 10             	add    $0x10,%esp
80107509:	39 45 10             	cmp    %eax,0x10(%ebp)
8010750c:	74 32                	je     80107540 <allocuvm+0xd0>
8010750e:	8b 55 10             	mov    0x10(%ebp),%edx
80107511:	89 c1                	mov    %eax,%ecx
80107513:	89 f8                	mov    %edi,%eax
80107515:	e8 96 fb ff ff       	call   801070b0 <deallocuvm.part.0>
      return 0;
8010751a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107524:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107527:	5b                   	pop    %ebx
80107528:	5e                   	pop    %esi
80107529:	5f                   	pop    %edi
8010752a:	5d                   	pop    %ebp
8010752b:	c3                   	ret    
8010752c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107539:	5b                   	pop    %ebx
8010753a:	5e                   	pop    %esi
8010753b:	5f                   	pop    %edi
8010753c:	5d                   	pop    %ebp
8010753d:	c3                   	ret    
8010753e:	66 90                	xchg   %ax,%ax
    return 0;
80107540:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010754a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010754d:	5b                   	pop    %ebx
8010754e:	5e                   	pop    %esi
8010754f:	5f                   	pop    %edi
80107550:	5d                   	pop    %ebp
80107551:	c3                   	ret    
80107552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	68 05 83 10 80       	push   $0x80108305
80107560:	e8 4b 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107565:	8b 45 0c             	mov    0xc(%ebp),%eax
80107568:	83 c4 10             	add    $0x10,%esp
8010756b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010756e:	74 0c                	je     8010757c <allocuvm+0x10c>
80107570:	8b 55 10             	mov    0x10(%ebp),%edx
80107573:	89 c1                	mov    %eax,%ecx
80107575:	89 f8                	mov    %edi,%eax
80107577:	e8 34 fb ff ff       	call   801070b0 <deallocuvm.part.0>
      kfree(mem);
8010757c:	83 ec 0c             	sub    $0xc,%esp
8010757f:	53                   	push   %ebx
80107580:	e8 fb ae ff ff       	call   80102480 <kfree>
      return 0;
80107585:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010758c:	83 c4 10             	add    $0x10,%esp
}
8010758f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107592:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <deallocuvm>:
{
801075a0:	f3 0f 1e fb          	endbr32 
801075a4:	55                   	push   %ebp
801075a5:	89 e5                	mov    %esp,%ebp
801075a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801075aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801075b0:	39 d1                	cmp    %edx,%ecx
801075b2:	73 0c                	jae    801075c0 <deallocuvm+0x20>
}
801075b4:	5d                   	pop    %ebp
801075b5:	e9 f6 fa ff ff       	jmp    801070b0 <deallocuvm.part.0>
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075c0:	89 d0                	mov    %edx,%eax
801075c2:	5d                   	pop    %ebp
801075c3:	c3                   	ret    
801075c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075cf:	90                   	nop

801075d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075d0:	f3 0f 1e fb          	endbr32 
801075d4:	55                   	push   %ebp
801075d5:	89 e5                	mov    %esp,%ebp
801075d7:	57                   	push   %edi
801075d8:	56                   	push   %esi
801075d9:	53                   	push   %ebx
801075da:	83 ec 0c             	sub    $0xc,%esp
801075dd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801075e0:	85 f6                	test   %esi,%esi
801075e2:	74 55                	je     80107639 <freevm+0x69>
  if(newsz >= oldsz)
801075e4:	31 c9                	xor    %ecx,%ecx
801075e6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801075eb:	89 f0                	mov    %esi,%eax
801075ed:	89 f3                	mov    %esi,%ebx
801075ef:	e8 bc fa ff ff       	call   801070b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801075f4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801075fa:	eb 0b                	jmp    80107607 <freevm+0x37>
801075fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107600:	83 c3 04             	add    $0x4,%ebx
80107603:	39 df                	cmp    %ebx,%edi
80107605:	74 23                	je     8010762a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107607:	8b 03                	mov    (%ebx),%eax
80107609:	a8 01                	test   $0x1,%al
8010760b:	74 f3                	je     80107600 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010760d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107612:	83 ec 0c             	sub    $0xc,%esp
80107615:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107618:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010761d:	50                   	push   %eax
8010761e:	e8 5d ae ff ff       	call   80102480 <kfree>
80107623:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107626:	39 df                	cmp    %ebx,%edi
80107628:	75 dd                	jne    80107607 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010762a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010762d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107630:	5b                   	pop    %ebx
80107631:	5e                   	pop    %esi
80107632:	5f                   	pop    %edi
80107633:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107634:	e9 47 ae ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80107639:	83 ec 0c             	sub    $0xc,%esp
8010763c:	68 21 83 10 80       	push   $0x80108321
80107641:	e8 4a 8d ff ff       	call   80100390 <panic>
80107646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764d:	8d 76 00             	lea    0x0(%esi),%esi

80107650 <setupkvm>:
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
80107655:	89 e5                	mov    %esp,%ebp
80107657:	56                   	push   %esi
80107658:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107659:	e8 e2 af ff ff       	call   80102640 <kalloc>
8010765e:	89 c6                	mov    %eax,%esi
80107660:	85 c0                	test   %eax,%eax
80107662:	74 42                	je     801076a6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107664:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107667:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010766c:	68 00 10 00 00       	push   $0x1000
80107671:	6a 00                	push   $0x0
80107673:	50                   	push   %eax
80107674:	e8 d7 d6 ff ff       	call   80104d50 <memset>
80107679:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010767c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010767f:	83 ec 08             	sub    $0x8,%esp
80107682:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107685:	ff 73 0c             	pushl  0xc(%ebx)
80107688:	8b 13                	mov    (%ebx),%edx
8010768a:	50                   	push   %eax
8010768b:	29 c1                	sub    %eax,%ecx
8010768d:	89 f0                	mov    %esi,%eax
8010768f:	e8 8c f9 ff ff       	call   80107020 <mappages>
80107694:	83 c4 10             	add    $0x10,%esp
80107697:	85 c0                	test   %eax,%eax
80107699:	78 15                	js     801076b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010769b:	83 c3 10             	add    $0x10,%ebx
8010769e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076a4:	75 d6                	jne    8010767c <setupkvm+0x2c>
}
801076a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076a9:	89 f0                	mov    %esi,%eax
801076ab:	5b                   	pop    %ebx
801076ac:	5e                   	pop    %esi
801076ad:	5d                   	pop    %ebp
801076ae:	c3                   	ret    
801076af:	90                   	nop
      freevm(pgdir);
801076b0:	83 ec 0c             	sub    $0xc,%esp
801076b3:	56                   	push   %esi
      return 0;
801076b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801076b6:	e8 15 ff ff ff       	call   801075d0 <freevm>
      return 0;
801076bb:	83 c4 10             	add    $0x10,%esp
}
801076be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076c1:	89 f0                	mov    %esi,%eax
801076c3:	5b                   	pop    %ebx
801076c4:	5e                   	pop    %esi
801076c5:	5d                   	pop    %ebp
801076c6:	c3                   	ret    
801076c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ce:	66 90                	xchg   %ax,%ax

801076d0 <kvmalloc>:
{
801076d0:	f3 0f 1e fb          	endbr32 
801076d4:	55                   	push   %ebp
801076d5:	89 e5                	mov    %esp,%ebp
801076d7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076da:	e8 71 ff ff ff       	call   80107650 <setupkvm>
801076df:	a3 c4 ae 11 80       	mov    %eax,0x8011aec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076e4:	05 00 00 00 80       	add    $0x80000000,%eax
801076e9:	0f 22 d8             	mov    %eax,%cr3
}
801076ec:	c9                   	leave  
801076ed:	c3                   	ret    
801076ee:	66 90                	xchg   %ax,%ax

801076f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076f0:	f3 0f 1e fb          	endbr32 
801076f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076f5:	31 c9                	xor    %ecx,%ecx
{
801076f7:	89 e5                	mov    %esp,%ebp
801076f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107702:	e8 99 f8 ff ff       	call   80106fa0 <walkpgdir>
  if(pte == 0)
80107707:	85 c0                	test   %eax,%eax
80107709:	74 05                	je     80107710 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010770b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010770e:	c9                   	leave  
8010770f:	c3                   	ret    
    panic("clearpteu");
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	68 32 83 10 80       	push   $0x80108332
80107718:	e8 73 8c ff ff       	call   80100390 <panic>
8010771d:	8d 76 00             	lea    0x0(%esi),%esi

80107720 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107720:	f3 0f 1e fb          	endbr32 
80107724:	55                   	push   %ebp
80107725:	89 e5                	mov    %esp,%ebp
80107727:	57                   	push   %edi
80107728:	56                   	push   %esi
80107729:	53                   	push   %ebx
8010772a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010772d:	e8 1e ff ff ff       	call   80107650 <setupkvm>
80107732:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107735:	85 c0                	test   %eax,%eax
80107737:	0f 84 9b 00 00 00    	je     801077d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010773d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107740:	85 c9                	test   %ecx,%ecx
80107742:	0f 84 90 00 00 00    	je     801077d8 <copyuvm+0xb8>
80107748:	31 f6                	xor    %esi,%esi
8010774a:	eb 46                	jmp    80107792 <copyuvm+0x72>
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107759:	68 00 10 00 00       	push   $0x1000
8010775e:	57                   	push   %edi
8010775f:	50                   	push   %eax
80107760:	e8 8b d6 ff ff       	call   80104df0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107765:	58                   	pop    %eax
80107766:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010776c:	5a                   	pop    %edx
8010776d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107770:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107775:	89 f2                	mov    %esi,%edx
80107777:	50                   	push   %eax
80107778:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010777b:	e8 a0 f8 ff ff       	call   80107020 <mappages>
80107780:	83 c4 10             	add    $0x10,%esp
80107783:	85 c0                	test   %eax,%eax
80107785:	78 61                	js     801077e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107787:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010778d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107790:	76 46                	jbe    801077d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107792:	8b 45 08             	mov    0x8(%ebp),%eax
80107795:	31 c9                	xor    %ecx,%ecx
80107797:	89 f2                	mov    %esi,%edx
80107799:	e8 02 f8 ff ff       	call   80106fa0 <walkpgdir>
8010779e:	85 c0                	test   %eax,%eax
801077a0:	74 61                	je     80107803 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801077a2:	8b 00                	mov    (%eax),%eax
801077a4:	a8 01                	test   $0x1,%al
801077a6:	74 4e                	je     801077f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801077a8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801077aa:	25 ff 0f 00 00       	and    $0xfff,%eax
801077af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801077b2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801077b8:	e8 83 ae ff ff       	call   80102640 <kalloc>
801077bd:	89 c3                	mov    %eax,%ebx
801077bf:	85 c0                	test   %eax,%eax
801077c1:	75 8d                	jne    80107750 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801077c3:	83 ec 0c             	sub    $0xc,%esp
801077c6:	ff 75 e0             	pushl  -0x20(%ebp)
801077c9:	e8 02 fe ff ff       	call   801075d0 <freevm>
  return 0;
801077ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801077d5:	83 c4 10             	add    $0x10,%esp
}
801077d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077de:	5b                   	pop    %ebx
801077df:	5e                   	pop    %esi
801077e0:	5f                   	pop    %edi
801077e1:	5d                   	pop    %ebp
801077e2:	c3                   	ret    
801077e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077e7:	90                   	nop
      kfree(mem);
801077e8:	83 ec 0c             	sub    $0xc,%esp
801077eb:	53                   	push   %ebx
801077ec:	e8 8f ac ff ff       	call   80102480 <kfree>
      goto bad;
801077f1:	83 c4 10             	add    $0x10,%esp
801077f4:	eb cd                	jmp    801077c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801077f6:	83 ec 0c             	sub    $0xc,%esp
801077f9:	68 56 83 10 80       	push   $0x80108356
801077fe:	e8 8d 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107803:	83 ec 0c             	sub    $0xc,%esp
80107806:	68 3c 83 10 80       	push   $0x8010833c
8010780b:	e8 80 8b ff ff       	call   80100390 <panic>

80107810 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107810:	f3 0f 1e fb          	endbr32 
80107814:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107815:	31 c9                	xor    %ecx,%ecx
{
80107817:	89 e5                	mov    %esp,%ebp
80107819:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010781c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010781f:	8b 45 08             	mov    0x8(%ebp),%eax
80107822:	e8 79 f7 ff ff       	call   80106fa0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107827:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107829:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010782a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010782c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107831:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107834:	05 00 00 00 80       	add    $0x80000000,%eax
80107839:	83 fa 05             	cmp    $0x5,%edx
8010783c:	ba 00 00 00 00       	mov    $0x0,%edx
80107841:	0f 45 c2             	cmovne %edx,%eax
}
80107844:	c3                   	ret    
80107845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107850 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107850:	f3 0f 1e fb          	endbr32 
80107854:	55                   	push   %ebp
80107855:	89 e5                	mov    %esp,%ebp
80107857:	57                   	push   %edi
80107858:	56                   	push   %esi
80107859:	53                   	push   %ebx
8010785a:	83 ec 0c             	sub    $0xc,%esp
8010785d:	8b 75 14             	mov    0x14(%ebp),%esi
80107860:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107863:	85 f6                	test   %esi,%esi
80107865:	75 3c                	jne    801078a3 <copyout+0x53>
80107867:	eb 67                	jmp    801078d0 <copyout+0x80>
80107869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107870:	8b 55 0c             	mov    0xc(%ebp),%edx
80107873:	89 fb                	mov    %edi,%ebx
80107875:	29 d3                	sub    %edx,%ebx
80107877:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010787d:	39 f3                	cmp    %esi,%ebx
8010787f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107882:	29 fa                	sub    %edi,%edx
80107884:	83 ec 04             	sub    $0x4,%esp
80107887:	01 c2                	add    %eax,%edx
80107889:	53                   	push   %ebx
8010788a:	ff 75 10             	pushl  0x10(%ebp)
8010788d:	52                   	push   %edx
8010788e:	e8 5d d5 ff ff       	call   80104df0 <memmove>
    len -= n;
    buf += n;
80107893:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107896:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010789c:	83 c4 10             	add    $0x10,%esp
8010789f:	29 de                	sub    %ebx,%esi
801078a1:	74 2d                	je     801078d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801078a3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801078a5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801078a8:	89 55 0c             	mov    %edx,0xc(%ebp)
801078ab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801078b1:	57                   	push   %edi
801078b2:	ff 75 08             	pushl  0x8(%ebp)
801078b5:	e8 56 ff ff ff       	call   80107810 <uva2ka>
    if(pa0 == 0)
801078ba:	83 c4 10             	add    $0x10,%esp
801078bd:	85 c0                	test   %eax,%eax
801078bf:	75 af                	jne    80107870 <copyout+0x20>
  }
  return 0;
}
801078c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078c9:	5b                   	pop    %ebx
801078ca:	5e                   	pop    %esi
801078cb:	5f                   	pop    %edi
801078cc:	5d                   	pop    %ebp
801078cd:	c3                   	ret    
801078ce:	66 90                	xchg   %ax,%ax
801078d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078d3:	31 c0                	xor    %eax,%eax
}
801078d5:	5b                   	pop    %ebx
801078d6:	5e                   	pop    %esi
801078d7:	5f                   	pop    %edi
801078d8:	5d                   	pop    %ebp
801078d9:	c3                   	ret    
