--Plunder Patroll Parrrty
--
--Script by JoyJ
function c101012091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101012091)
	e1:SetCondition(c101012091.condition)
	e1:SetTarget(c101012091.target)
	e1:SetOperation(c101012091.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012091,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101012091+100+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c101012091.eqcon)
	e2:SetTarget(c101012091.eqtg)
	e2:SetOperation(c101012091.eqop)
	c:RegisterEffect(e2)
end
function c101012091.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13f)
end
function c101012091.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101012091.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101012091.drfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c101012091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local i=Duel.GetMatchingGroupCount(c101012091.drfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,i+1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(i+1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,i+1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,i)
end
function c101012091.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local i=Duel.GetMatchingGroupCount(c101012091.drfilter,p,LOCATION_ONFIELD,0,nil)
	if Duel.Draw(p,i+1,REASON_EFFECT)==0 then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,i,i,nil)
	if i>0 then
		Duel.BreakEffect()
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function c101012091.exfilter(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetSummonPlayer()==tp and c:IsSetCard(0x13f) and c:IsFaceup()
end
function c101012091.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101012091.exfilter,1,nil,tp)
end
function c101012091.eqfilter(c,g)
	return g:IsContains(c)
end
function c101012091.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c101012091.exfilter,nil,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden()
		and c:CheckUniqueOnField(tp,LOCATION_SZONE)
		and Duel.IsExistingMatchingCard(c101012091.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c101012091.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if c:IsForbidden() or not c:CheckUniqueOnField(tp,LOCATION_SZONE) then return end
	local g=eg:Filter(c101012091.exfilter,nil,tp)
	local sg=Duel.SelectMatchingCard(tp,c101012091.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	local tc=sg:GetFirst()
	if tc then
		Duel.HintSelection(sg)
		if Duel.Equip(tp,c,tc) then
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c101012091.eqlimit)
			c:RegisterEffect(e1)
			--Atk up
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(500)
			c:RegisterEffect(e2)
		end
	end
end
function c101012091.eqlimit(e,c)
	return c==e:GetLabelObject()
end