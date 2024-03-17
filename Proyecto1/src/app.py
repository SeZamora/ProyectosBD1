from flask import Flask
from db.Consultas.crearmodelo import CrearModelo
from db.Consultas.cargatemp import CrearTemp
from db.Consultas.borrarmodelo import BorrarModelo
from db.Consultas.borrarinfo import BorrarInfoTablas
from db.Consultas.Consulta.consulta1 import Consulta1
from db.Consultas.Consulta.consulta2 import Consulta2
from db.Consultas.Consulta.consulta3 import Consulta3
from db.Consultas.Consulta.consulta4 import Consulta4
from db.Consultas.Consulta.consulta5 import Consulta5
from db.Consultas.Consulta.consulta6 import Consulta6
from db.Consultas.Consulta.consulta7 import Consulta7
from db.Consultas.Consulta.consulta8 import Consulta8
from db.Consultas.Consulta.consulta9 import Consulta9
from db.Consultas.Consulta.consulta10 import Consulta10

app = Flask(__name__)

@app.route("/crearmodelo", methods=["GET"]) 
def crearmodel():
    return CrearModelo()

@app.route("/cargarmodelo", methods=["GET"])
def cargatemp():
    return CrearTemp()

@app.route("/eliminarmodelo", methods=["GET"])
def borrarmodelo():
    return BorrarModelo()

@app.route("/borrarinfodb", methods=["GET"])
def eliminarinfo():
    return BorrarInfoTablas()

@app.route("/consulta1", methods=["GET"])
def consulta():
    return Consulta1()

@app.route("/consulta2", methods=["GET"])
def consulta2():
    return Consulta2()

@app.route("/consulta3", methods=["GET"])
def consulta3():
    return Consulta3()

@app.route("/consulta4", methods=["GET"])
def consulta4():
    return Consulta4()

@app.route("/consulta5", methods=["GET"])
def consulta5():
    return Consulta5()

@app.route("/consulta6", methods=["GET"])
def consulta6():
    return Consulta6()

@app.route("/consulta7", methods=["GET"])
def consulta7():
    return Consulta7()

@app.route("/consulta8", methods=["GET"])
def consulta8():
    return Consulta8()

@app.route("/consulta9", methods=["GET"])
def consulta9():
    return Consulta9()

@app.route("/consulta10", methods=["GET"])
def consulta10():
    return Consulta10()