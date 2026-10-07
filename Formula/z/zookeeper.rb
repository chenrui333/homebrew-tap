class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4.tar.gz"
  sha256 "b84d0847d5b56c984fe3e50fdd28702340e66db5fd00701fa553d9899b09cabe"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  livecheck do
    skip "forked formula"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3843c9736f1b6fe8a0fc34b42354bc9016dcf604e7ecc3788c4aa654c1e46dda"
    sha256 cellar: :any, arm64_sequoia: "b8bb1bcf5a1e7fb758c477c65f5b0a0113b2e79622268a1aab246057623769d9"
    sha256 cellar: :any, arm64_linux:   "2006bc52bf17f30a488b15a176a8130be53b7c575e428a0cb4c7d9d8873c49e1"
    sha256 cellar: :any, x86_64_linux:  "5acaf1f140c3bd588508c7019c7ab1d3386da6235af64224b86fd8b0f36b31bd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build

  depends_on "openjdk@21"
  depends_on "openssl@3"

  # Maven resolves plugins and artifacts for the full-build profile during packaging; go-offline does not cover them.
  allow_network_access! :build

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{pkgetc}"
    EOS
  end

  def install
    system "mvn", "install", "-Pfull-build", "-DskipTests"

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-bin.tar.gz"
    binpfx = "apache-zookeeper-#{version}-bin"
    libexec.install binpfx+"/bin", binpfx+"/lib", "zookeeper-contrib"
    rm(Dir["build-bin/bin/*.cmd"])

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-lib.tar.gz"
    libpfx = "apache-zookeeper-#{version}-lib"
    include.install Dir[libpfx+"/usr/include/*"]
    lib.install Dir[libpfx+"/usr/lib/*"]

    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec/"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{formula_opt_prefix("openjdk@21")}}"
        . "#{pkgetc}/defaults"
        exec "#{libexec}/bin/#{script_name}" "$@"
      EOS
    end

    (buildpath/"defaults").write(default_zk_env)
    cp "conf/logback.xml", "logback.xml"
    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    inreplace "conf/zoo.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    pkgetc.install "conf/zoo.cfg", "defaults", "logback.xml"
    (pkgshare/"examples").install "conf/logback.xml", "conf/zoo_sample.cfg"
  end

  service do
    run [opt_bin/"zkServer", "start-foreground"]
    environment_variables SERVER_JVMFLAGS: "-Dapple.awt.UIElement=true"
    keep_alive successful_exit: false
    working_dir var
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{pkgetc}/zoo.cfg", output
  end
end
