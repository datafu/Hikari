; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -mtriple=x86_64-unknown -mattr=+avx -slp-vectorizer | FileCheck %s

;void phiUsingLoads(int *restrict A, int *restrict B) {
;  int tmp0, tmp1, tmp2, tmp3;
;  for (int i = 0; i < 100; i++) {
;    if (A[0] == 0) {
;      tmp0 = A[i + 0];
;      tmp1 = A[i + 1];
;      tmp2 = A[i + 2];
;      tmp3 = A[i + 3];
;    } else if (A[25] == 0) {
;      tmp0 = A[i + 0];
;      tmp1 = A[i + 1];
;      tmp2 = A[i + 2];
;      tmp3 = A[i + 3];
;    } else if (A[50] == 0) {
;      tmp0 = A[i + 0];
;      tmp1 = A[i + 1];
;      tmp2 = A[i + 2];
;      tmp3 = A[i + 3];
;    } else if (A[75] == 0) {
;      tmp0 = A[i + 0];
;      tmp1 = A[i + 1];
;      tmp2 = A[i + 3];
;      tmp3 = A[i + 2];
;    }
;  }
;  B[0] = tmp0;
;  B[1] = tmp1;
;  B[2] = tmp2;
;  B[3] = tmp3;
;}


; Function Attrs: norecurse nounwind uwtable
define void @phiUsingLoads(i32* noalias nocapture readonly %A, i32* noalias nocapture %B) local_unnamed_addr #0 {
; CHECK-LABEL: @phiUsingLoads(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A:%.*]], align 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    [[ARRAYIDX12:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 25
; CHECK-NEXT:    [[ARRAYIDX28:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 50
; CHECK-NEXT:    [[ARRAYIDX44:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 75
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[ARRAYIDX64:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i64 1
; CHECK-NEXT:    [[ARRAYIDX65:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 2
; CHECK-NEXT:    [[ARRAYIDX66:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP27:%.*]], <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi <4 x i32> [ undef, [[ENTRY]] ], [ [[TMP27]], [[FOR_INC]] ]
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX11:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[ARRAYIDX2]] to <4 x i32>*
; CHECK-NEXT:    [[TMP7:%.*]] = load <4 x i32>, <4 x i32>* [[TMP6]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX12]], align 4
; CHECK-NEXT:    [[CMP13:%.*]] = icmp eq i32 [[TMP8]], 0
; CHECK-NEXT:    br i1 [[CMP13]], label [[IF_THEN14:%.*]], label [[IF_ELSE27:%.*]]
; CHECK:       if.then14:
; CHECK-NEXT:    [[ARRAYIDX17:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP9:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX20:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX23:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP11:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX26:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP11]]
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast i32* [[ARRAYIDX17]] to <4 x i32>*
; CHECK-NEXT:    [[TMP13:%.*]] = load <4 x i32>, <4 x i32>* [[TMP12]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else27:
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[ARRAYIDX28]], align 4
; CHECK-NEXT:    [[CMP29:%.*]] = icmp eq i32 [[TMP14]], 0
; CHECK-NEXT:    br i1 [[CMP29]], label [[IF_THEN30:%.*]], label [[IF_ELSE43:%.*]]
; CHECK:       if.then30:
; CHECK-NEXT:    [[ARRAYIDX33:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP15:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX36:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP15]]
; CHECK-NEXT:    [[TMP16:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX39:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP17:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX42:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i32* [[ARRAYIDX33]] to <4 x i32>*
; CHECK-NEXT:    [[TMP19:%.*]] = load <4 x i32>, <4 x i32>* [[TMP18]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else43:
; CHECK-NEXT:    [[TMP20:%.*]] = load i32, i32* [[ARRAYIDX44]], align 4
; CHECK-NEXT:    [[CMP45:%.*]] = icmp eq i32 [[TMP20]], 0
; CHECK-NEXT:    br i1 [[CMP45]], label [[IF_THEN46:%.*]], label [[FOR_INC]]
; CHECK:       if.then46:
; CHECK-NEXT:    [[ARRAYIDX49:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP21:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX52:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP21]]
; CHECK-NEXT:    [[TMP22:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX55:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP23:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX58:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP23]]
; CHECK-NEXT:    [[TMP24:%.*]] = bitcast i32* [[ARRAYIDX49]] to <4 x i32>*
; CHECK-NEXT:    [[TMP25:%.*]] = load <4 x i32>, <4 x i32>* [[TMP24]], align 4
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <4 x i32> [[TMP25]], <4 x i32> undef, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[TMP27]] = phi <4 x i32> [ [[TMP7]], [[IF_THEN]] ], [ [[TMP13]], [[IF_THEN14]] ], [ [[TMP19]], [[IF_THEN30]] ], [ [[TMP26]], [[IF_THEN46]] ], [ [[TMP2]], [[IF_ELSE43]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
;
entry:
  %0 = load i32, i32* %A, align 4
  %cmp1 = icmp eq i32 %0, 0
  %arrayidx12 = getelementptr inbounds i32, i32* %A, i64 25
  %arrayidx28 = getelementptr inbounds i32, i32* %A, i64 50
  %arrayidx44 = getelementptr inbounds i32, i32* %A, i64 75
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.inc
  store i32 %tmp0.1, i32* %B, align 4
  %arrayidx64 = getelementptr inbounds i32, i32* %B, i64 1
  store i32 %tmp1.1, i32* %arrayidx64, align 4
  %arrayidx65 = getelementptr inbounds i32, i32* %B, i64 2
  store i32 %tmp2.1, i32* %arrayidx65, align 4
  %arrayidx66 = getelementptr inbounds i32, i32* %B, i64 3
  store i32 %tmp3.1, i32* %arrayidx66, align 4
  ret void

for.body:                                         ; preds = %for.inc, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
  %tmp3.0111 = phi i32 [ undef, %entry ], [ %tmp3.1, %for.inc ]
  %tmp2.0110 = phi i32 [ undef, %entry ], [ %tmp2.1, %for.inc ]
  %tmp1.0109 = phi i32 [ undef, %entry ], [ %tmp1.1, %for.inc ]
  %tmp0.0108 = phi i32 [ undef, %entry ], [ %tmp0.1, %for.inc ]
  br i1 %cmp1, label %if.then, label %if.else

if.then:                                          ; preds = %for.body
  %arrayidx2 = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx2, align 4
  %2 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx5 = getelementptr inbounds i32, i32* %A, i64 %2
  %3 = load i32, i32* %arrayidx5, align 4
  %4 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx8 = getelementptr inbounds i32, i32* %A, i64 %4
  %5 = load i32, i32* %arrayidx8, align 4
  %6 = add nuw nsw i64 %indvars.iv, 3
  %arrayidx11 = getelementptr inbounds i32, i32* %A, i64 %6
  %7 = load i32, i32* %arrayidx11, align 4
  br label %for.inc

if.else:                                          ; preds = %for.body
  %8 = load i32, i32* %arrayidx12, align 4
  %cmp13 = icmp eq i32 %8, 0
  br i1 %cmp13, label %if.then14, label %if.else27

if.then14:                                        ; preds = %if.else
  %arrayidx17 = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  %9 = load i32, i32* %arrayidx17, align 4
  %10 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx20 = getelementptr inbounds i32, i32* %A, i64 %10
  %11 = load i32, i32* %arrayidx20, align 4
  %12 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx23 = getelementptr inbounds i32, i32* %A, i64 %12
  %13 = load i32, i32* %arrayidx23, align 4
  %14 = add nuw nsw i64 %indvars.iv, 3
  %arrayidx26 = getelementptr inbounds i32, i32* %A, i64 %14
  %15 = load i32, i32* %arrayidx26, align 4
  br label %for.inc

if.else27:                                        ; preds = %if.else
  %16 = load i32, i32* %arrayidx28, align 4
  %cmp29 = icmp eq i32 %16, 0
  br i1 %cmp29, label %if.then30, label %if.else43

if.then30:                                        ; preds = %if.else27
  %arrayidx33 = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  %17 = load i32, i32* %arrayidx33, align 4
  %18 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx36 = getelementptr inbounds i32, i32* %A, i64 %18
  %19 = load i32, i32* %arrayidx36, align 4
  %20 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx39 = getelementptr inbounds i32, i32* %A, i64 %20
  %21 = load i32, i32* %arrayidx39, align 4
  %22 = add nuw nsw i64 %indvars.iv, 3
  %arrayidx42 = getelementptr inbounds i32, i32* %A, i64 %22
  %23 = load i32, i32* %arrayidx42, align 4
  br label %for.inc

if.else43:                                        ; preds = %if.else27
  %24 = load i32, i32* %arrayidx44, align 4
  %cmp45 = icmp eq i32 %24, 0
  br i1 %cmp45, label %if.then46, label %for.inc

if.then46:                                        ; preds = %if.else43
  %arrayidx49 = getelementptr inbounds i32, i32* %A, i64 %indvars.iv
  %25 = load i32, i32* %arrayidx49, align 4
  %26 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx52 = getelementptr inbounds i32, i32* %A, i64 %26
  %27 = load i32, i32* %arrayidx52, align 4
  %28 = add nuw nsw i64 %indvars.iv, 3
  %arrayidx55 = getelementptr inbounds i32, i32* %A, i64 %28
  %29 = load i32, i32* %arrayidx55, align 4
  %30 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx58 = getelementptr inbounds i32, i32* %A, i64 %30
  %31 = load i32, i32* %arrayidx58, align 4
  br label %for.inc

for.inc:                                          ; preds = %if.then, %if.then30, %if.else43, %if.then46, %if.then14
  %tmp0.1 = phi i32 [ %1, %if.then ], [ %9, %if.then14 ], [ %17, %if.then30 ], [ %25, %if.then46 ], [ %tmp0.0108, %if.else43 ]
  %tmp1.1 = phi i32 [ %3, %if.then ], [ %11, %if.then14 ], [ %19, %if.then30 ], [ %27, %if.then46 ], [ %tmp1.0109, %if.else43 ]
  %tmp2.1 = phi i32 [ %5, %if.then ], [ %13, %if.then14 ], [ %21, %if.then30 ], [ %29, %if.then46 ], [ %tmp2.0110, %if.else43 ]
  %tmp3.1 = phi i32 [ %7, %if.then ], [ %15, %if.then14 ], [ %23, %if.then30 ], [ %31, %if.then46 ], [ %tmp3.0111, %if.else43 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 100
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}