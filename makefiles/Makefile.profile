all:							stamp.pred-all

stamp.pred:						stamp.pred-all
stamp.preds:					stamp.pred-all
stamp.spred:					stamp.pred-all

stamp.pred-all:					stamp.xml
	profile2preds && touch stamp.pred stamp.preds stamp.spred stamp.pred-all
	
stamp.xml:						stamp.mrs
	profile2xml && touch stamp.xml

stamp.mrs:						result
	profile2mrs && touch stamp.mrs

clean:
	rm -f stamp.*
	
cleanall:						clean
	rm -rf *0 *.mrs

.PHONY:							all clean cleanall
