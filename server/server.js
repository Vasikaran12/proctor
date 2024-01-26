const express = require('express')
const {Pool} = require('pg');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.urlencoded({extended: false}));
app.use(express.json());
app.use(cors());

const pool = new Pool({
  connectionString: process.env.DB_URL
});

app.get('/faculties', async (req, res) => {
    try{
        await pool.query(`select * from faculty;`, (err, results) => {
            if(err){
                console.log(err.message);
            }else{
                console.log(results.rows);
        res.status(200).send(results.rows);
            }
        });
    }catch(e){
        console.log(e.message);
        res.status(500).send({error: e.message});
    }
})

app.get('/checkStudent',(req, res) => {
    try{
        const email = req.query.email
        console.log({email});
        pool.query(`select s.name, s.email, s.phone, s.regnum, f.name as pname, f.email as pemail, f.phone as pphone 
                    from student s, faculty f 
                    where s.proctor = f.email and s.email = $1`, [email], async (err, results) => {
            if(err){
                console.log(err.message);
                res.status(500).send({error: err.message});
            }else{
                console.log(results.rows);
                if(results.rows.length == 0){
                    res.sendStatus(400);
                }else{
                    res.status(200).send(results.rows[0]);
                }
            }
        });
    }catch(e){
        console.log(e.message);
        res.status(500).send({error: e.message});
    }
})

app.get('/checkFaculty',(req, res) => {
    try{
        const email = req.query.email
        console.log({email});
        pool.query(`select name, email, phone
                    from faculty 
                    where email = $1`, [email], async (err, results) => {
            if(err){
                console.log(err.message);
                res.status(500).send({error: err.message});
            }else{
                console.log(results.rows);
                if(results.rows[0]['phone'] == null){
                    res.sendStatus(400);
                }else{
                    res.status(200).send(results.rows[0]);
                }
            }
        });
    }catch(e){
        console.log(e.message);
        res.status(500).send({error: e.message});
    }
})

app.post('/addStudent', async (req, res) => {
    try{
        let {name, email, phone, regnum, proctor} = req.body;
        console.log({name, email, phone, regnum, proctor});
        await pool.query(`with inserted_student as (
            insert into student(name, email, phone, regnum, proctor) 
            values($1, $2, $3, $4, $5)
            returning name, email, phone, regnum, proctor
          )
          select s.*, f.name as pname, f.email as pemail, f.phone as pphone
          from inserted_student s
          join faculty f on s.proctor = f.email;`, [name, email, phone, regnum, proctor], (err, results) => {
            if(err){
                console.log(err.message);
                res.status(500).send({error: err.message});
            }else{
                console.log(results.rows);
                res.status(200).send(results.rows[0]);
            }
        });
    }catch(e){
        console.log(e.message);
        res.status(500).send({error: e.message});
    }
})

app.post('/addFaculty', async (req, res) => {
    try{
        let {name, email, phone} = req.body;
        console.log({name, email, phone});
        await pool.query(`
        update faculty
        set name = $1, phone = $2
        where email = $3
        returning name, email, phone`, [name, phone, email], (err, results) => {
            if(err){
                console.log(err.message);
                res.status(500).send({error: err.message});
            }else{
                console.log(results.rows);
                res.status(200).send(results.rows[0]);
            }
        });
    }catch(e){
        console.log(e.message);
        res.status(500).send({error: e.message});
    }
})

app.listen(PORT, () => {
    console.log(`Server running on ${PORT}`);
});