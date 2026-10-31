class Claudebox < Formula
  desc "Sandboxed launcher for Claude Code"
  homepage "https://github.com/numtide/claudebox"
  url "https://github.com/numtide/claudebox/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "766616a3aab21bbb4bbf6bbce00eb4d089383bb1405d465dc8d7738c42f53416"
  license "MIT"
  head "https://github.com/numtide/claudebox.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b6c0c03cd364f2e928471bb2633e971fde84b13fdc8791c7e9ab07ceeef6fdc3"
  end

  depends_on "bash"
  depends_on "node"

  on_linux do
    depends_on "bubblewrap"
  end

  deny_network_access!

  def install
    libexec.install "src/claudebox.js"
    chmod 0755, libexec/"claudebox.js"
    pkgshare.install "src/seatbelt.sbpl"
    paths = %w[node bash].map { |name| formula_opt_bin(name) }
    (bin/"claudebox").write_env_script libexec/"claudebox.js",
                                     PATH:                       "#{paths.join(":")}:$PATH",
                                     CLAUDEBOX_SEATBELT_PROFILE: (pkgshare/"seatbelt.sbpl").to_s,
                                     DISABLE_AUTOUPDATER:        "1"
  end

  def caveats
    <<~EOS
      Claude Code is not bundled and must be installed separately.
      The upstream launcher skips Claude's interactive permission prompts;
      upstream does not describe this sandbox as a security boundary.
      On Linux, upstream also requires a host Nix installation at /nix.
    EOS
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    # Never let an argument-parsing regression launch a real provider during validation.
    (testpath/"bin/claude").write "#!/bin/sh\nexit 97\n"
    chmod 0755, testpath/"bin/claude"
    ENV.prepend_path "PATH", testpath/"bin"

    output = shell_output("#{bin}/claudebox --homebrew-invalid 2>&1", 1)
    assert_match "Unknown option: --homebrew-invalid", output

    (testpath/"config/claudebox/config.json").write "{"
    output = shell_output("#{bin}/claudebox --homebrew-invalid 2>&1", 1)
    assert_match "Failed to load config", output
    refute_path_exists testpath/".claude"
  end
end
