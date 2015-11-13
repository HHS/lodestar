package uk.ac.ebi.fgpt.lode.servlet;

import uk.ac.ebi.fgpt.lode.exception.LodeException;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;

@ResponseStatus(value = HttpStatus.NOT_FOUND, reason = "The specified object was not found on this server")
public class LodeNotFoundException extends LodeException {
    public LodeNotFoundException() {
        super();
    }

    public LodeNotFoundException(String message) {
        super(message);
    }

    public LodeNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

    public LodeNotFoundException(Throwable cause) {
        super(cause);
    }
}

