/** Metadata about a deployment */
function Deployment(_deployment_id, _name, _size) constructor {
	self.deployment_id = _deployment_id;
	self.name = _name;
	self.size = _size;
	self.created = date_current_datetime();
}