--エレメントセイバー・ウィラード
--Elementsaber Willard
--Scripted by Eerie Code
function c101004025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101004025)
	e1:SetCost(c101004025.spcost)
	e1:SetTarget(c101004025.sptg)
	e1:SetOperation(c101004025.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101004025.regcon)
	e2:SetOperation(c101004025.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
end
function c101004025.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x400d) or c:IsLocation(LOCATION_HAND))
end
function c101004025.regfilter(c,attr)
	return c:IsSetCard(0x400d) and c:GetOriginalAttribute()&attr~=0
end
function c101004025.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=Duel.IsPlayerAffectedByEffect(tp,101004060)
	local loc=LOCATION_HAND
	if fc then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c101004020.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101004020.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,101004060)
		local field=Duel.GetFirstMatchingCard(Card.IsHasEffect,tp,LOCATION_ONFIELD,0,nil,101004060)
		if field then field:RegisterFlagEffect(101004060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0) end
	end
	local flag=0
	if g:IsExists(c101004025.regfilter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then flag=flag+1 end
	if g:IsExists(c101004025.regfilter,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then flag=flag+2 end
	if g:IsExists(c101004025.regfilter,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then flag=flag+4 end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function c101004025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101004025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101004025.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0
end
function c101004025.regop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c101004025.immtg)
	if flag&1 then
		local e1=e0:Clone()
		e1:SetDescription(aux.Stringid(101004025,1))
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
	if flag&2 then
		local e2=e0:Clone()
		e2:SetDescription(aux.Stringid(101004025,2))
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
	if flag&4 then
		local e3=e0:Clone()
		e3:SetDescription(aux.Stringid(101004025,3))
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		c:RegisterEffect(e3)
	end
end
function c101004025.immtg(e,c)
	return c:IsSetCard(0x400d) or c:IsSetCard(0x212)
end
