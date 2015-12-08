(ns p2.core
  (:gen-class))

(defn toHexString
  [bytes]
  (format
    (str "%0" (bit-shift-left (alength bytes) 1) "x")
    (new java.math.BigInteger 1 bytes)))

(defn digest
  [value]
  (.digest
    (java.security.MessageDigest/getInstance "md5")
    (.getBytes value "UTF-8")))

(defn md5-string
  [source]
  (toHexString (digest source)))

(defn -main
  "Problem 2 of Day 4"
  [& args]
  ; (println (take 10 (range 999))))
  (println (take 10
    ; (filter (fn [s] (.startsWith s "00000")) (map md5-string (map (fn [n] (str "abcd" n))(range 999999))))
    (filter (fn [v] (.startsWith (nth v 1) "000000")) (map (fn [v] [(nth v 0) (md5-string (nth v 1))]) (map (fn [n] [n (str "iwrupvqb" n)]) (range 99999999))))
  )))
  ; (println (first (filter (fn [n] (.startsWith n "00000")) (map md5-string
