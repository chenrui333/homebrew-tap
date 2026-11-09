class OrbiCli < Formula
  include Language::Python::Virtualenv

  desc "Run coding agents on labeled GitHub issues"
  homepage "https://orbi.build"
  url "https://files.pythonhosted.org/packages/62/8b/cd4aa84ea3c392a391c37473c16145012e77507fd6e9a8b781c38d9d3f0b/orbi_cli-0.7.39.tar.gz"
  sha256 "560950a8700f46cd0e8809a22f2eed9c8d5c42ec8d52a7ace5bacd29a395e6f5"
  license "AGPL-3.0-only"
  head "https://github.com/orbi-build/orbi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4cd566b9733c60d3f54e77ea4f47cdedc562b1757df7fbabc423eb2472e67d26"
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
