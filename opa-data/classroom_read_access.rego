package classroom_read_access

default allow = false

classroom_belongs_to_teacher_classroom(classroomID, teacherID) {
    teacherClassrooms[tc]
    tc.teacherID == teacherID
    tc.classroomID == classroomID
}

classroom_belongs_to_teacher_org_unit(classroomID, teacherID) {
    classroom_belongs_to_teacher_classroom(classroomID, teacherID)
    classrooms[classroom]
    classroom.id == classroomID
    orgUnits[ou]
    ou.id == classroom.orgUnitID
    teaches_in_org_unit[teacherID][ou.id]
}

teaches_in_classroom[teacherID] {
    teacherClassrooms[tc]
    tc.teacherID == teacherID
    classroomIDs[classroomID]
    tc.classroomID == classroomID
}

teaches_in_org_unit[teacherID] {
    classroom_belongs_to_teacher_classroom(classroomID, teacherID)
    classrooms[classroom]
    classroom.id == classroomID
    orgUnits[ou]
    ou.id == classroom.orgUnitID
}

classroomIDs[classroomID] {
    teaches_in_classroom[teacherID]
    classroomIDs[classroomID]
}

classrooms[classroom] {
    input.resource.type == "classrooms"
    classroom = input.resource
}

orgUnits[ou] {
    input.resource.type == "orgUnits"
    ou = input.resource
}

allow {
    input.action == "read"
    input.teacher_id == input.resource.teacher_id
    classroom_belongs_to_teacher_classroom(input.resource.id, input.teacher_id)
}

allow {
    input.action == "read"
    input.teacher_id == input.resource.teacher_id
    classroom_belongs_to_teacher_org_unit(input.resource.id, input.teacher_id)
}
