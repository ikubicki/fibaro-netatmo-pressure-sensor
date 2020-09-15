--[[
Netatmo Pressure Sensor
@author ikubicki
]]

function QuickApp:onInit()
    self.config = Config:new(self)
    self.auth = Auth:new(self.config)
    self.http = HTTPClient:new({
        baseUrl = 'https://api.netatmo.com/api'
    })
    self.i18n = i18n:new(api.get("/settings/info").defaultLanguage)
    self:trace('')
    self:trace('Netatmo pressure sensor')
    self:trace('User:', self.config:getUsername())
    self:updateProperty('manufacturer', 'Netatmo')
    self:updateProperty('manufacturer', 'Pressure sensor')
    self:updateView("label2", "text", string.format(self.i18n:get('Pressure'), 0))
    self:run()
end

function QuickApp:run()
    self:pullNetatmoData()
    local interval = self.config:getTimeoutInterval()
    if (interval > 0) then
        fibaro.setTimeout(interval, function() self:run() end)
    end
end

function QuickApp:pullNetatmoData()
    local url = '/getstationsdata'
    self:updateView("button1", "text", self.i18n:get('please-wait'))
    if string.len(self.config:getDeviceID()) > 3 then
        -- QuickApp:debug('Pulling data for device ' .. self.config:getDeviceID())
        url = url .. '?device_id=' .. self.config:getDeviceID()
    else
        -- QuickApp:debug('Pulling data')
    end
    local callback = function(response)
        local data = json.decode(response.data)
        if data.error and data.error.message then
            QuickApp:error(data.error.message)
            return false
        end
        local device = data.body.devices[1]
        
        if device ~= nil then
            self:updateProperty("value", device.dashboard_data.Pressure)
            self:updateProperty("unit", "mbar")
            self:updateView("label2", "text", string.format(self.i18n:get('Pressure'), device.dashboard_data.Pressure))
            self:trace('[' .. device['_id'] .. '] Pressure information updated')
            self:updateView("label1", "text", string.format(self.i18n:get('last-update'), os.date('%Y-%m-%d %H:%M:%S')))
            self:updateView("button1", "text", self.i18n:get('refresh'))
                
            if string.len(self.config:getDeviceID()) < 4 then
                self.config:setDeviceID(device["_id"])
            end
        else
            self:error('Unable to retrieve device data')
        end
    end
    
    self.http:get(url, callback, nil, self.auth:getHeaders({}))
    
    return {}
end

function QuickApp:button1Event()
    self:pullNetatmoData()
end