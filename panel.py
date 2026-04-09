from flask import Flask, request, redirect, session, render_template_string
import uuid, json, os, time

app = Flask(__name__)
app.secret_key = "secure123"

DB = "users.json"
XRAY = "xray.json"

USERNAME = "admin"
PASSWORD = "admin"

def load():
    if not os.path.exists(DB):
        return []
    return json.load(open(DB))

def save(data):
    json.dump(data, open(DB,"w"), indent=2)

def sync_xray(users):
    inbounds = []
    port = 10001

    for u in users:
        if u["expired"] < time.time():
            continue

        path = f"/{u['id'][:6]}"

        inbounds.append({
            "port": port,
            "protocol": "vless",
            "settings": {"clients":[{"id":u["id"]}]},
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path": path,
                    "headers":{"Host":"vless.anugerah-ternak-sejagad.xyz"}
                }
            }
        })

        u["port"] = port
        u["path"] = path
        port += 1

    config = {
        "log":{"loglevel":"warning"},
        "inbounds": inbounds,
        "outbounds":[{"protocol":"freedom"}],
        "dns":{"servers":["1.1.1.1","1.0.0.1","8.8.8.8"]}
    }

    json.dump(config, open(XRAY,"w"), indent=2)

    os.system("pkill -f xray")
    os.system("xray run -c xray.json &")

@app.route("/", methods=["GET","POST"])
def login():
    if request.method == "POST":
        if request.form["user"] == USERNAME and request.form["pw"] == PASSWORD:
            session["login"] = True
            return redirect("/panel")

    return "<h2 style='color:#0ff;background:black;text-align:center'>LOGIN</h2><form method=post><input name=user><input name=pw type=password><button>LOGIN</button></form>"

@app.route("/panel")
def panel():
    if not session.get("login"):
        return redirect("/")

    users = load()

    html = """
    <body style='background:black;color:#0ff;font-family:monospace'>
    <h2>💰 VLESS PANEL</h2>

    <form method=post action=/create>
    Nama: <input name=nama>
    Hari: <input name=days>
    <button>CREATE</button>
    </form>

    <table border=1 width=100%%>
    <tr><th>Nama</th><th>Status</th><th>Link</th><th>Delete</th></tr>

    {% for u in users %}
    <tr>
    <td>{{u.nama}}</td>
    <td>{% if u.expired > now %}AKTIF{% else %}EXPIRED{% endif %}</td>
    <td>{{u.link}}</td>
    <td><a href="/delete/{{u.id}}">❌</a></td>
    </tr>
    {% endfor %}
    </table>
    </body>
    """
    return render_template_string(html, users=users, now=time.time())

@app.route("/create", methods=["POST"])
def create():
    users = load()

    uid = str(uuid.uuid4())
    nama = request.form["nama"]
    days = int(request.form.get("days",1))

    expired = int(time.time()) + (days * 86400)

    users.append({
        "id": uid,
        "nama": nama,
        "expired": expired
    })

    sync_xray(users)

    for u in users:
        u["link"] = f"vless://{u['id']}@vless.anugerah-ternak-sejagad.xyz:443?type=ws&path={u.get('path','/')}&security=tls"

    save(users)

    return redirect("/panel")

@app.route("/delete/<id>")
def delete(id):
    users = load()
    users = [u for u in users if u["id"] != id]

    sync_xray(users)
    save(users)

    return redirect("/panel")

app.run(host="0.0.0.0", port=5000)
