class Ministack < Formula
  include Language::Python::Virtualenv

  desc "Local AWS service emulator and LocalStack replacement"
  homepage "https://github.com/ministackorg/ministack"
  url "https://files.pythonhosted.org/packages/bf/e8/fd0343f852a71880b2ddd9e6ae552f027f142a5336e399b0a046f4f75768/ministack-1.4.19.tar.gz"
  sha256 "e2b58951ce1c3611220bdf9dad60f4252fa0d14597ffa0c0bda9418f00a1a9af"
  license "MIT"
  head "https://github.com/ministackorg/ministack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f39594a9c8e4734b9ecb0882b6dbac0be7ead432b9bd73e8cfdbdbeb1f9526b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08c129f123deeaee9e37c00e69b281d476f1c17f7cb2fc2d3e769e5068bebce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c38f2bf62fef43f3ee62fe19f29f62dcdfab192a27fc49559899274b0b56b95"
    sha256 cellar: :any,                 arm64_linux:   "b4b2ca754ecfbfc30f25213d39c7a348ae000b2c2c6f45bab183aa4a0dbf866b"
    sha256 cellar: :any,                 x86_64_linux:  "207b653042ffd3343527f317b495bfe3d87c4c05f10592f817a901a64d27eba2"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "hypercorn" do
    url "https://files.pythonhosted.org/packages/44/01/39f41a014b83dd5c795217362f2ca9071cf243e6a75bdcd6cd5b944658cc/hypercorn-0.18.0.tar.gz"
    sha256 "d63267548939c46b0247dc8e5b45a9947590e35e64ee73a23c074aa3cf88e9da"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "priority" do
    url "https://files.pythonhosted.org/packages/f5/3c/eb7c35f4dcede96fca1842dac5f4f5d15511aa4b52f3a961219e68ae9204/priority-2.0.0.tar.gz"
    sha256 "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  def install
    (var/"ministack").mkpath
    (var/"ministack/state").mkpath
    (var/"ministack/s3").mkpath

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  service do
    run [opt_bin/"ministack"]
    keep_alive true
    working_dir var/"ministack"
    environment_variables GATEWAY_PORT:   "4566",
                          MINISTACK_HOST: "localhost",
                          PERSIST_STATE:  "1",
                          S3_DATA_DIR:    var/"ministack/s3",
                          S3_PERSIST:     "1",
                          STATE_DIR:      var/"ministack/state"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    port = free_port
    log = testpath/"ministack.log"
    state_dir = testpath/"state"
    s3_dir = testpath/"s3"

    pid = spawn({ "GATEWAY_PORT"   => port.to_s,
                  "MINISTACK_HOST" => "127.0.0.1",
                  "PERSIST_STATE"  => "1",
                  "S3_DATA_DIR"    => s3_dir.to_s,
                  "S3_PERSIST"     => "1",
                  "STATE_DIR"      => state_dir.to_s },
                bin/"ministack",
                [:out, :err] => log.to_s)

    begin
      20.times do
        break if quiet_system "curl", "-fsS", "http://127.0.0.1:#{port}/_ministack/health"

        sleep 1
      end

      output = shell_output("curl -fsS http://127.0.0.1:#{port}/_ministack/health")
      assert_match "\"edition\": \"light\"", output
      assert_match "\"s3\": \"available\"", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
