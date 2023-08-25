package classroom_write_access

default allow = false

classroom_teacher[teacher_id] {
    teacherClassrooms[tc]
    tc.teacherID == teacher_id
}

allow {
    input.action == "modify"
    input.resource.type == "classrooms"
    input.teacher_id == input.resource.teacher_id
    classroom_teacher[input.teacher_id]
}
