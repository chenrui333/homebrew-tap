class OrbiCli < Formula
  include Language::Python::Virtualenv

  desc "Run coding agents on labeled GitHub issues"
  homepage "https://orbi.build"
  url "https://files.pythonhosted.org/packages/17/a0/62d25eba0975f98ba040f9d037a96b8ad59fd0484378880ed6b32b7ab80d/orbi_cli-0.7.28.tar.gz"
  sha256 "fb980cd4139e641120240a3a5bf6429468ede52d1946f8b6dfea62a482b6e059"
  license "AGPL-3.0-only"
  head "https://github.com/orbi-build/orbi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ddeb6de54ec26beeac50d3c19664b094559d2b27f2ae32ea898fa8f94bce50a6"
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
