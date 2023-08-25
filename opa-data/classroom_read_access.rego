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
    teaches_in_classroom[teacherID][classroom.id]
}

teaches_in_classroom[teacherID] = {classroomID | classroom_belongs_to_teacher_classroom(classroomID, teacherID)}

teaches_in_org_unit[teacherID] = {classroomID | classroom_belongs_to_teacher_org_unit(classroomID, teacherID)}

allow {
    input.action == "read"
    input.resource.type == "classrooms"
    input.teacher_id == input.resource.teacher_id
    (classroom_belongs_to_teacher_classroom(input.resource.id, input.teacher_id) or
    classroom_belongs_to_teacher_org_unit(input.resource.id, input.teacher_id))
}
