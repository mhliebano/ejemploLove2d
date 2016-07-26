--ESCRITO POR MIGUEL HERNANDEZ LIEBANO (mhliebano@gmail.com)
function love.load()
	fondo=love.graphics.newImage("recursos/bg_1_1.png")
	nave=love.graphics.newImage("recursos/player.png")
	enemigo=love.graphics.newImage("recursos/attackship.png")
	roca1=love.graphics.newImage("recursos/asteroid-big-0000.png")
	roca2=love.graphics.newImage("recursos/asteroid-big-0010.png")
	roca3=love.graphics.newImage("recursos/asteroid-big-0018.png")
	explosion=love.graphics.newImage("recursos/ex.png")
	balas=love.graphics.newImage("recursos/M484BulletCollection1.png")
	posX=20
	posY=280
	puntos=0
	vida=100
	balita=love.graphics.newQuad(158,215,16,12,balas:getWidth(),balas:getHeight())
	balacera={}
	enemigos={}

	musica=love.audio.newSource("recursos/spaceship.wav")
	musica:setLooping(true)
	musica:play()
	
	disparo=love.audio.newSource("recursos/Shoot.wav")
	expl=love.audio.newSource("recursos/explosion.wav")
    es=0
end

function love.update(dt)
	if love.keyboard.isDown( "up" ) and posY>=0 and vida>0 then
		posY=posY-(120*dt)
	end
	if love.keyboard.isDown( "down" ) and posY<=540 and vida>0 then
		posY=posY+(120*dt)
	end
	if love.keyboard.isDown( "left" ) and posX>=0 and vida>0 then
		posX=posX-(120*dt)
	end
	if love.keyboard.isDown( "right" ) and posX<=740 and vida>0then
		posX=posX+(120*dt)
	end
	mueveBala(dt)
	creaEnemigo(dt)
	mueveEnemigo(dt)
end

function love.draw()
	love.graphics.draw(fondo,0,0)
	if vida>0 then 
		love.graphics.draw(nave,posX,posY)
		dibujaBala()
	else
		love.graphics.print("Juego Finalizado",380,270)
		posX=-2
		posY=-60
	end
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("line",10,10,110,30)
	love.graphics.rectangle("fill",15,15,vida,20)
	love.graphics.setColor(255,255,70)
	love.graphics.print(puntos,45,45)
	love.graphics.setColor(255, 255, 255)
	--love.graphics.draw(balas,balita,200,250)
	dibujaEnemigo()
	--love.graphics.print(y,100,100)
end

function love.keyreleased(key)
	if key==" " and vida>0 then
		table.insert(balacera,{x=posX+nave:getWidth(),y=posY+nave:getHeight()/2})
		disparo:play()
	end
end

function dibujaBala()
	for i,b in ipairs(balacera) do
		love.graphics.draw(balas,balita,b.x,b.y)
	end
end

function mueveBala(t)
	for i,b in ipairs(balacera) do
		b.x=b.x+(400*t)
		if b.x>800 then
           table.remove(balacera,i)
       end
	end
end

function creaEnemigo(t)
    es=es+t
    if (es>1) then
        es=0
        math.randomseed(os.time())
        if math.random()>0.3 then
            local ti = math.random(1,4)
            local y=math.random(50,550)
            table.insert(enemigos,{pX=815,pY=y,tipo=ti})
        end
    end
end

function dibujaEnemigo()
	for i,e in ipairs(enemigos) do
		if e.tipo==1 then
			love.graphics.draw(enemigo,e.pX,e.pY,0,0.2,0.2,enemigo:getWidth()*0.2, enemigo:getHeight()*0.2)
		elseif e.tipo==2 then
			love.graphics.draw(roca1,e.pX,e.pY,0,0.3,0.3,roca1:getWidth()*0.3, roca1:getHeight()*0.3)
		elseif e.tipo==3 then
			love.graphics.draw(roca2,e.pX,e.pY,0,0.2,0.2,roca2:getWidth()*0.2, roca2:getHeight()*0.2)
		elseif e.tipo==4 then
			love.graphics.draw(roca3,e.pX,e.pY,0,0.2,0.2,roca3:getWidth()*0.2, roca3:getHeight()*0.2)
		end
	end
end

function mueveEnemigo(t)
	for i,e in ipairs(enemigos) do
		if e.tipo==1 then
			e.pX=e.pX-(240*t)
		else
			e.pX=e.pX-(200*t)
		end
		if e.pX<=posX+50 and e.pY>=posY and e.pY<=posY+80 then
			vida=vida-15
			table.remove(enemigos,i)
			expl:play()
		end
        for j,b in ipairs(balacera) do
			if b.x+50>=e.pX and b.y>=e.pY and b.y<=e.pY+50 then
				table.remove(balacera,j)
				table.remove(enemigos,i)
				puntos=puntos+250
				expl:play()
			end
		end
		if e.pX<-25 then
			if e.tipo==1 then
				vida=vida-10
			end
			table.remove(enemigos,i)
		end
	end

end
