const express = require('express')
const {Pool} = require('pg');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

let { PGHOST, PGDATABASE, PGUSER, PGPASSWORD, ENDPOINT_ID } = process.env;

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

app.get('/checkUser',(req, res) => {
    try{
        const email = req.query.email
        const name = req.query.name;
        console.log({email, name});
        pool.query(`select * from student where email = $1`, [email], async (err, results) => {
            if(err){
                console.log(err.message);
                res.status(500).send({error: err.message});
            }else{
                console.log(results.rows);
                if(results.rows.length == 0){
                    pool.query(`insert into student(email, name) values($1, $2);`, [email, name], (err, results) => {
                        if(err){
                            console.log(err.message);
                            res.status(500).send({error: err.message});
                        }else{
                            console.log(results.rows);
                            res.status(200).send(results.rows[0]);
                        }
                    });
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

app.use(cors());
app.listen(PORT, () => {
    console.log(`Server running on ${PORT}`);
});