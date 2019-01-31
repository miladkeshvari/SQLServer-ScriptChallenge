;With FirstCTE
As	(
		Select	*
		,	(
				Select	Count(Id)
				From	tbl_test	As InnerTest
				Where	InnerTest.col1 = tbl_test.col1
				And	InnerTest.col2 = tbl_test.col2
				And	InnerTest.col3 = tbl_test.col3
				And	InnerTest.metr = 30
			)	As CountThirty
		,	(
				Select	Concat(' + ' , metr)
				From	tbl_test	As InnerTest
				Where	InnerTest.col1 = tbl_test.col1
				And	InnerTest.col2 = tbl_test.col2
				And	InnerTest.col3 = tbl_test.col3
				And	InnerTest.metr != 30
				For XML Path('')
			)	As OtherMeter
		From	tbl_test
),AfterMerge
As (
	Select	*
	,	Concat(FirstCTE.CountThirty , ' * 30 ' , FirstCTE.OtherMeter)	As FinalComment
	From	FirstCTE
)
, FinalResult
As(
	Select	AfterMerge.col1
	,	AfterMerge.col2
	,	AfterMerge.col3
	,	Sum(AfterMerge.metr)		As metr
	,	Sum(AfterMerge.tedad)		As tedad
	,	AfterMerge.FinalComment		As Comment
	From	AfterMerge
	Group By	AfterMerge.col1
	,		AfterMerge.col2
	,		AfterMerge.col3
	,		AfterMerge.FinalComment
)
Select	*
From	FinalResult