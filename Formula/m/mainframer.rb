class Mainframer < Formula
  desc "Tool for remote builds"
  homepage "https://github.com/buildfoundation/mainframer"
  url "https://github.com/buildfoundation/mainframer/archive/80695e57a4978f8b5ac474ceae0612422c09d7ab.tar.gz"
  version "3.0.0"
  sha256 "654c785af992269eea68f2ea80ae832e019eace0c79d5e7655d84e4758c0ecf9"
  license "Apache-2.0"

  livecheck do
    skip "no tagged releases for v3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/mainframer --version", 1)
    assert_match version.to_s, output

    (testpath/".mainframer/config.yml").write <<~YAML
      remote:
        host: "localhost"
        path: "/tmp"
      push:
        compression: 1
    YAML

    # # The authenticity of host 'localhost (::1)' can't be established.
    # # ED25519 key fingerprint is SHA256:E56kyK/Xd5a9l+Eyga/H71/63HFpdEeaxJ/pWsA49b8.
    # # This key is not known by any other names.
    # # Are you sure you want to continue connecting (yes/no/[fingerprint])? Killing child processes...
    # return if OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = if OS.mac?
      pipe_output("#{bin}/mainframer echo 'Hello, world!' 2>&1", "yes\n", 1)
    else
      shell_output("#{bin}/mainframer echo 'Hello, world!' 2>&1", 1)
    end

    expected = if OS.mac?
      "rsync stderr 'ssh: connect to host localhost port 22"
    else
      "rsync stderr 'Host key verification failed"
    end
    assert_match expected, output
  end
end
