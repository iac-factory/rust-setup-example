#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdint.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

extern int errno;

int runtime() {
    int buffer = open("buffer", O_WRONLY);

    printf("%s\n", "Initializing");

    pid_t pid = fork();

    if (pid == -1) return 1;
    else if (!pid || pid == 0) {
        /// Child Namespace (Primary)

        dup2(buffer, 1);

        execl("/bin/echo", "echo", "...");

        close(buffer);
    } else {
        /// Parent Namespace (Controller)

        wait(NULL);
    }

    /// Common Namespace (Child + Parent)

    close(buffer);

    return 0;
}
