package org_unit_read_access

default allow = false

direct_parent(orgUnitID, parentID) {
    orgUnits[parent]
    parent.id == parentID
    orgUnitID == parent.parent
}

teaches_in_classroom(teacherID, classroomID) {
    teacherClassrooms[tc]
    tc.teacherID == teacherID
    classrooms[classroom]
    tc.classroomID == classroom.id
    classroom.orgUnitID == orgUnitID
}

allow {
    input.action == "read"
    input.resource.type == "orgUnits"
    input.teacher_id == input.resource.teacher_id
    teaches_in_classroom[input.teacher_id][input.resource.id]
    orgUnits[ou]
    ou.id == input.resource.id
    direct_parent(ou.id, classroom.orgUnitID)
}
