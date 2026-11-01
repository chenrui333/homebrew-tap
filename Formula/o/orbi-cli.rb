class OrbiCli < Formula
  include Language::Python::Virtualenv

  desc "Run coding agents on labeled GitHub issues"
  homepage "https://orbi.build"
  url "https://files.pythonhosted.org/packages/1f/e5/d95609b84f315aef08d2f502a884709b928975a3ca4bbf3a7ab31883a6d6/orbi_cli-0.7.30.tar.gz"
  sha256 "044901c5697710123cc0de9789db25915e5850c233797a694638d6c2f2e96373"
  license "AGPL-3.0-only"
  head "https://github.com/orbi-build/orbi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b51ff78f8f43309ac4e7cc2ce9d1afe81345929c024b832fc691145c5e3d4091"
  end

  depends_on "python-setuptools" => :build
  depends_on "gh"
  depends_on "pi-coding-agent"
  depends_on "python@3.15"

  deny_network_access!

  def install
    venv = virtualenv_create(libexec, "python3.15")
    venv.pip_install_and_link buildpath, build_isolation: false
    pkgshare.install "src/orbi/example_config.toml"
  end

  def caveats
    <<~EOS
      Configure #{etc}/orbi.toml before starting the service.
      An example configuration is installed at #{pkgshare}/example_config.toml.
    EOS
  end

  service do
    run [opt_bin/"orbi", "--config", etc/"orbi.toml"]
    run_type :interval
    interval 60
    environment_variables PATH: std_service_path_env
    log_path var/"log/orbi.log"
    error_log_path var/"log/orbi.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orbi --version")

    output = shell_output("#{bin}/orbi status --config #{testpath}/missing.toml 2>&1", 1)
    assert_match "config_not_found", output
    assert_match "missing.toml", output
  end
end
