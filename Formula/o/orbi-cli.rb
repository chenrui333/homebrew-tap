class OrbiCli < Formula
  include Language::Python::Virtualenv

  desc "Run coding agents on labeled GitHub issues"
  homepage "https://orbi.build"
  url "https://files.pythonhosted.org/packages/63/68/fe9c3605cf9e26ed535e408751882cb0a2e666ec1c3b4a29a3e984c10729/orbi_cli-0.7.40.tar.gz"
  sha256 "bdc295a49534e53d172a2f544a92251efe2784df05d95732992ad527edd0ed8f"
  license "AGPL-3.0-only"
  head "https://github.com/orbi-build/orbi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b08e61f08b320f4750a7af1567149901cfd9d630a1e5f6c52aeb5014c71a856a"
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
