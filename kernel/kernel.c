void kernel_main(){
    char *video = (char*)0xB8000;
    const char *message = "Welcome to MeowOS!";

    for(int i = 0; message[i] != '\0'; i++){
        video[i * 2] = message[i];
        video[i * 2 + 1] = 0x07;
    }

    while(1);
}
