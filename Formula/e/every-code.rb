class EveryCode < Formula
  desc "Orchestrate coding agents from OpenAI, Claude, Gemini, and other providers"
  homepage "https://github.com/just-every/code"
  url "https://github.com/just-every/code/archive/refs/tags/v0.6.196.tar.gz"
  sha256 "3e1a7df62c0c48cf18c197958e42452fac6220534e7d20ee13adb8ea1c440253"
  license "Apache-2.0"
  head "https://github.com/just-every/code.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    cd "code-rs" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["CODE_VERSION"] = version.to_s
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "false"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "16"
    cd "code-rs" do
      # Keep upstream's private binary names, but do not shadow VS Code or core's coder.
      inreplace "cli/src/main.rs", 'CLI_COMMAND_NAME: &str = "code"', 'CLI_COMMAND_NAME: &str = "every-code"'
      inreplace "cli/src/main.rs", 'bin_name = "code"', 'bin_name = "every-code"'
      %w[cli tui exec].each do |crate|
        system "cargo", "install", *std_cargo_args(path: crate, root: libexec)
      end
    end
    %w[code code-tui code-exec].each do |exe|
      public_name = exe.sub(/^code/, "every-code")
      (bin/public_name).write_env_script libexec/"bin"/exe, PATH: "#{libexec}/bin:$PATH"
    end
    generate_completions_from_executable(bin/"every-code", "completion", base_name: "every-code")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/every-code --version")
    (testpath/"code-home").mkpath
    ENV["CODE_HOME"] = testpath/"code-home"
    ENV.delete "OPENAI_API_KEY"
    ENV.delete "CODE_API_KEY"
    assert_match "Not logged in", shell_output("#{bin}/every-code login status 2>&1", 1)
  end
end
