trap "{ echo Stopping logstash ; exit 0; }" TERM

echo Starting logstash
sed -i.bak s/-Xms256m/-Xms${ENV_JVM_Xms}/g /etc/logstash/jvm.options
sed -i.bak s/-Xmx1g/-Xmx${ENV_JVM_Xmx}/g /etc/logstash/jvm.options

/usr/share/logstash/bin/logstash --config.reload.automatic --path.settings /etc/logstash

sleep 1
PID=$!
wait $PID
