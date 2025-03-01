class Pingu < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/sheepla/pingu"
  url "https://github.com/sheepla/pingu/archive/926d475bda0fb27987e314cd9451c3e60976e643.tar.gz"
  version "0.0.5"
  sha256 "f7bb5dde9b1c9c358d3b57b04000c08f30d53721efb5594ea9eda830b3ea671f"
  license "MIT"
  head "https://github.com/sheepla/pingu.git", branch: "master"

  livecheck do
    skip "no recent releases"
  end

  depends_on "go" => :build

  # update `golang.org/x/net`
  patch :DATA

  def install
    ldflags = "-s -w -X main.appVersion=#{version} -X main.appRevision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pingu --version")

    # /o/h/L/T/c/homebrew-tap (pingu) > pingu -c 1 github.com
    # PING github.com (140.82.112.4) type `Ctrl-C` to abort
    #  ...        .     ...   ..    ..     .........            seq=0 32bytes from 140.82.112.4: ttl=49 time=23.611ms

    # ───────── github.com ping statistics ─────────
    # PACKET STATISTICS: 1 transmitted => 1 received (0% loss)
    # ROUND TRIP: min=23.611ms avg=23.611ms max=23.611ms stddev=0s
    output = shell_output("#{bin}/pingu -c 1 github.com")
    assert_match <<~EOS, output
      ───────── github.com ping statistics ─────────
      PACKET STATISTICS: 1 transmitted => 1 received (0% loss)
    EOS
  end
end

__END__
diff --git a/go.mod b/go.mod
index 0bba250..36f28b6 100644
--- a/go.mod
+++ b/go.mod
@@ -12,7 +12,7 @@ require (
 	github.com/google/uuid v1.3.0 // indirect
 	github.com/mattn/go-colorable v0.1.9 // indirect
 	github.com/mattn/go-isatty v0.0.14 // indirect
-	golang.org/x/net v0.0.0-20220615171555-694bf12d69de // indirect
+	golang.org/x/net v0.35.0 // indirect
 	golang.org/x/sync v0.0.0-20220601150217-0de741cfad7f // indirect
-	golang.org/x/sys v0.0.0-20220615213510-4f61da869c0c // indirect
+	golang.org/x/sys v0.30.0 // indirect
 )
diff --git a/go.sum b/go.sum
index 1f8a75e..6500bcd 100644
--- a/go.sum
+++ b/go.sum
@@ -11,13 +11,13 @@ github.com/mattn/go-isatty v0.0.14 h1:yVuAays6BHfxijgZPzw+3Zlu5yQgKGP2/hcQbHb7S9
 github.com/mattn/go-isatty v0.0.14/go.mod h1:7GGIvUiUoEMVVmxf/4nioHXj79iQHKdU27kJ6hsGG94=
 github.com/prometheus-community/pro-bing v0.1.0 h1:zjzLGhfNPP0bP1OlzGB+SJcguOViw7df12LPg2vUJh8=
 github.com/prometheus-community/pro-bing v0.1.0/go.mod h1:BpWlHurD9flHtzq8wrh8QGWYz9ka9z9ZJAyOel8ej58=
-golang.org/x/net v0.0.0-20220615171555-694bf12d69de h1:ogOG2+P6LjO2j55AkRScrkB2BFpd+Z8TY2wcM0Z3MGo=
-golang.org/x/net v0.0.0-20220615171555-694bf12d69de/go.mod h1:XRhObCWvk6IyKnWLug+ECip1KBveYUHfp+8e9klMJ9c=
+golang.org/x/net v0.35.0 h1:T5GQRQb2y08kTAByq9L4/bz8cipCdA8FbRTXewonqY8=
+golang.org/x/net v0.35.0/go.mod h1:EglIi67kWsHKlRzzVMUD93VMSWGFOMSZgxFjparz1Qk=
 golang.org/x/sync v0.0.0-20220601150217-0de741cfad7f h1:Ax0t5p6N38Ga0dThY21weqDEyz2oklo4IvDkpigvkD8=
 golang.org/x/sync v0.0.0-20220601150217-0de741cfad7f/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
 golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20210320140829-1e4c9ba3b0c4/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
-golang.org/x/sys v0.0.0-20220615213510-4f61da869c0c h1:aFV+BgZ4svzjfabn8ERpuB4JI4N6/rdy1iusx77G3oU=
-golang.org/x/sys v0.0.0-20220615213510-4f61da869c0c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
+golang.org/x/sys v0.30.0 h1:QjkSwP/36a20jFYWkSue1YwXzLmsV5Gfq7Eiy72C1uc=
+golang.org/x/sys v0.30.0/go.mod h1:/VUhepiaJMQUp4+oa/7Zr1D23ma6VTLIYjOOTFZPUcA=
