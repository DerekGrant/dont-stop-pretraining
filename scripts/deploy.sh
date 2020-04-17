root_model_dir=$1
dataset=$2
server=$3

if [[ $dataset == "rct-sample" ]];
then
    domain="med"
    big=2
    oracle_tapt=1
    perf="+accuracy"
elif [[ $dataset == "rct-20k" ]];
then
    domain="med"
    big=1
    oracle_tapt=0
    perf="+accuracy"
elif [[ $dataset == "amazon" ]];
then
    domain="reviews"
    big=1
    oracle_tapt=0
    perf="+f1"
elif [[ $dataset == "imdb" ]];
then
    domain="reviews"
    big=1
    oracle_tapt=1
    perf="+f1"
elif [[ $dataset == "chemprot" ]];
then
    domain="med"
    big=0
    oracle_tapt=0
    perf="+accuracy"
elif [[ $dataset == "ag" ]];
then
    domain="news"
    big=1
    oracle_tapt=0
    perf="+f1"
elif [[ $dataset == "hyperpartisan_news" ]];
then
    domain="news"
    big=2
    oracle_tapt=1
    perf="+f1"
elif [[ $dataset == "citation_intent" ]];
then
    domain="cs"
    big=0
    oracle_tapt=0
    perf="+f1"
elif [[ $dataset == "sciie" ]];
then
    domain="cs"
    big=0
    oracle_tapt=0
    perf="+f1"
fi



## ROBERTA-BASE
bash scripts/run.sh roberta-base classifier citation_intent $big base $perf $server
## DAPT
bash scripts/run.sh $root_model_dir/$domain-roberta classifier $dataset $big dapt $perf $server
## TAPT
bash scripts/run.sh $root_model_dir/$dataset/roberta-tapt/ classifier $dataset $big tapt $perf $server

## UNDOMAIN
if [[ $domain == "news" ]];
then
    bash scripts/run.sh $root_model_dir/med-roberta classifier $dataset $big undomain $perf $server
else
    bash scripts/run.sh $root_model_dir/news-roberta classifier $dataset $big undomain $perf $server
fi

## DAPT+TAPT
bash scripts/run.sh $root_model_dir/$dataset/roberta-dapt-tapt/ classifier $dataset $big dapt_tapt $perf $server

## ORACLE TAPT / DAPT + ORACLE-TAPT
if [[ $oracle_tapt == 1 ]];
then
    bash scripts/run.sh $root_model_dir/$dataset/roberta-oracle-tapt/ classifier $dataset $big oracle_tapt $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-dapt-oracle-tapt/ classifier $dataset $big dapt_oracle_tapt $perf $server
fi

## TRANSFER TAPTS
if [$[ dataset == "amazon" ]];
then
    bash scripts/run.sh $root_model_dir/imdb/roberta-oracle-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "imdb" ]];
then
    bash scripts/run.sh $root_model_dir/amazon/roberta-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "rct-20k" ]];
then
    bash scripts/run.sh $root_model_dir/chemprot/roberta-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "chemprot" ]];
then
    bash scripts/run.sh $root_model_dir/rct-20k/roberta-oracle-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "sciie" ]];
then
    bash scripts/run.sh $root_model_dir/citation_intent/roberta-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "citation_intent" ]];
then
    bash scripts/run.sh $root_model_dir/sciie/roberta-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "ag" ]];
then
    bash scripts/run.sh $root_model_dir/hyperpartisan_news/roberta-oracle-tapt classifier $dataset $big transfer_tapt $perf $server
elif [[ $dataset == "hyperpartisan_news" ]];
then
    bash scripts/run.sh $root_model_dir/ag/roberta-tapt classifier $dataset $big transfer_tapt $perf $server
fi

if [[ $dataset == "citation_intent" ]];
then
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-50 classifier $dataset $big knn_50 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-150 classifier $dataset $big knn_150 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-500 classifier $dataset $big knn_500 $perf $server
    bash scripts/run.sh $root_model_dir/citation_intent/roberta-rand-k-50 classifier citation_intent 0 rand_knn_50 +f1 allennlp-server4
elif [[ $dataset == "rct-sample" ]];
then
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-50 classifier $dataset $big knn_50 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-150 classifier $dataset $big knn_150 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-500 classifier $dataset $big knn_500 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-rand-k-50 classifier $dataset $big rand_knn_50 $perf $server
elif [[ $dataset == "chemprot" ]];
then
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-50 classifier $dataset $big knn_50 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-150 classifier $dataset $big knn_150 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-k-500 classifier $dataset $big knn_500 $perf $server
    bash scripts/run.sh $root_model_dir/$dataset/roberta-rand-k-50 classifier $dataset $big rand_knn_50 $perf $server
fi