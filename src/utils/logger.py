import logging


class Logger:
    # atributos privados
    __instance = None
    __initialized = False
    __logger = None

    # Cria instancia
    def __new__(cls):
        if cls.__instance is None:
            cls.__instance = super(Logger, cls).__new__(cls)
        return cls.__instance

    def __init__(self):
        # só configura se for a primeira vez
        if not self.__initialized:
            self.__logger = logging.getLogger("DadosLogger")
            self.__logger.setLevel("INFO")

            handler = logging.StreamHandler()
            formatter = logging.Formatter(
                "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            )
            handler.setFormatter(formatter)
            self.__logger.addHandler(handler)

            self.__initialized = True

    def get_logger(self):
        """Devolve o logger configurado"""
        return self.__logger
