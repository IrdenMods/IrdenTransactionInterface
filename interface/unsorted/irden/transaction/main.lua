require("/scripts/messageutil.lua")

local WIDGETS = {
    TBX_AMOUNT = "strimg_tbx_background.tbx_amount",
    LBL_NAME = "lyt_description.lbl_name",
    LBL_DESCRIPTION = "lyt_description.lbl_description"
}

---@class Configuration
---@field account string -- account uuid
---@field name string
---@field description string

function init()
    ---@type Configuration
    self.data = config.getParameter("data")
    aggregateNameFromServer()
end

function send(name, data)
    local amount = widget.getText(WIDGETS.TBX_AMOUNT)
    if not amount or amount == "" then
        interface.queueMessage("Значение не может быть пустым!")
    end
    sendAmount(amount)
end

function aggregateNameFromServer()
    promises:add(
            world.sendEntityMessage("server", "irden:account:name", self.data.account),
            function(result)
                widget.setText(WIDGETS.LBL_NAME, result[1])
                widget.setText(WIDGETS.LBL_DESCRIPTION, result[2])
            end, function(er)
                chat.addMessage(er)
                pane.dismiss()
            end

    )
end

function sendAmount(amount)
    promises:add(
            world.sendEntityMessage(
                    "server", "irden:account:transfer", {
                        account = self.data.account,
                        amount = amount
                    }
            ), function(result)
                if result then
                    interface.queueMessage(result)
                end
                if not result then
                    pane.dismiss()
                end
            end,
            function(er)
                chat.addMessage(er)
                pane.dismiss()
            end
    )
end

function update()
    promises:update()
end

function uninit()

end