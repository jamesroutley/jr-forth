# Forth

A forth implementation in `x86` assembly.

## Vagrant

Development is done in a Ubuntu 16.04 VM, managed by Vagrant. To start the VM,
run:

```
vagrant up
```

from the root directory of this repo. To connect to the VM, run:

```
vagrant ssh
```

Installed packages:

- `nasm`
- `gcc`
- `gdb`
- `make`
- `gcc-multilib`

## Resources

Forth:

- [A Beginner's Guide to Forth](http://galileo.phys.virginia.edu/classes/551.jvn.fall01/primer.htm)

Assembly:

- [Hello World](http://asm.sourceforge.net/intro/hello.html)
- [Guide to x86 Assembly](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html)
- [Programming from the Groud Up](https://download-mirror.savannah.gnu.org/releases/pgubook/ProgrammingGroundUp-1-0-booksize.pdf)

## Debug

### Clock skew detected

I experienced an issue with `Make`:

```sh
$ make clean
make: Warning: File 'Makefile' has modification time 1153 s in the future
rm -f hello hello.o
make: warning:  Clock skew detected.  Your build may be incomplete.
```

This turned out to be an issue with clock drift on the VM. If the host
machine sleeps, when it wakes up, the VM's internal clock continues from where
it left off, making the time incorrect if compared to the host.

Vagrant synchronises a directory between the host and the VM, copying over host
changes to files. These changes include an edit date, accessible by running
`ls -lat`. I was editing the Makefile on the host machine, giving an edit time
that was in the future on the host machine.

Luckily, this is easy to fix. Virtualbox already synchronises the time every
20 minutes, so we can solve this by increasing the synchronisation rate.

Find out the vm name:

```sh
$ VBoxManage ls vms
"forth_default_xxxx" {<uuid>}
# ... other vms you may have
$ VBoxManage guestproperty set forth_default_xxxx \
    "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold" 10000
```

## Plan

Word:

- read next word in the input buffer. Push word to the stack

- params
    - pointer to current position through input string
- returns
    - pointer to word - needs to store the word somewhere?
    -
<!--- need pointer to current position through word-->
