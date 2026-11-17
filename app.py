
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Temporary in-memory task storage
tasks = [
    {"id": 1, "title": "Buy groceries", "completed": False},
    {"id": 2, "title": "Renew subscription", "completed": False},
    {"id": 3, "title": "Exercise for 30 minutes", "completed": True}
]


@app.route("/")
def home():
    return render_template("index.html", tasks=tasks)


@app.route("/add", methods=["POST"])
def add_task():
    title = request.form.get("title", "").strip()

    if title:
        new_id = max([task["id"] for task in tasks], default=0) + 1

        tasks.append({
            "id": new_id,
            "title": title,
            "completed": False
        })

    return redirect(url_for("home"))


@app.route("/complete/<int:task_id>")
def complete_task(task_id):
    for task in tasks:
        if task["id"] == task_id:
            task["completed"] = not task["completed"]
            break

    return redirect(url_for("home"))



@app.route("/delete/<int:task_id>")
def delete_task(task_id):
    tasks[:] = [task for task in tasks if task["id"] != task_id]

    return redirect(url_for("home"))



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
