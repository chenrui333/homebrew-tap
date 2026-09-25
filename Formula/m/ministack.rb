class Ministack < Formula
  include Language::Python::Virtualenv

  desc "Local AWS service emulator and LocalStack replacement"
  homepage "https://github.com/ministackorg/ministack"
  url "https://files.pythonhosted.org/packages/bf/a1/4eb68e76d9d813cd5a589154a7a178376309cbefddbe5c5344460c8a8b9f/ministack-1.5.15.tar.gz"
  sha256 "947202b704082a8e7e955f28ff3bc34501c4754ba0213e52e375823227f469d4"
  license "MIT"
  head "https://github.com/ministackorg/ministack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "759cc5dfb860120d83808a24d88548a528481619737ae179866f56a79ac86800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45ec92b35a9f3899c95e6d901c54ad54776193617aa6a9b6a1296d434e1d3f7"
    sha256 cellar: :any,                 arm64_linux:   "bd25fb3965bb4644114f0bcc1afbf285b5302ff56651db31fe6eecf2fe39a4d5"
    sha256 cellar: :any,                 x86_64_linux:  "6dce65eddc7742cea91984a93c41705cdff0417a361f5dc87d2e3d046fa27230"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e1/5f/b33913aab846bc88a2720976435adb944d1ef57b92beed829233fe1953d9/botocore-1.43.63.tar.gz"
    sha256 "854e45247f00b0732496ea1f0c5d0cf3c31d58b48eb052c31c27ab1087dfddf1"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/11/7f/671c1046fe72ba5b62be2de3979ea9e61cb3dba8f1edfb880b811f8bdf8b/graphql_core-3.2.12.tar.gz"
    sha256 "4579094d5fc8a1a59555a9b18e51b320779d9bbc63e2302c519af0c4919d9543"
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

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonata-python" do
    url "https://files.pythonhosted.org/packages/9d/6a/b756e10939f584b0629c301bb4aa0e79f94163ac3b0083c788b8ee78c708/jsonata_python-0.7.0.tar.gz"
    sha256 "2cf788147a0d444cb9d7d81c58da9991607280d6a5d0f06bd2dd212a59fdcb16"
  end

  resource "priority" do
    url "https://files.pythonhosted.org/packages/f5/3c/eb7c35f4dcede96fca1842dac5f4f5d15511aa4b52f3a961219e68ae9204/priority-2.0.0.tar.gz"
    sha256 "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
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
