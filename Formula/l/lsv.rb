class Lsv < Formula
  desc "Three Pane Terminal File Viewer"
  homepage "https://github.com/SecretDeveloper/lsv"
  url "https://static.crates.io/crates/lsv/lsv-0.1.11.crate"
  sha256 "7fef93920b47348fb35e4b27c80427cb87351fa4e09a77c2e9d7e8f9d03d274d"
  license "MIT"
  head "https://github.com/SecretDeveloper/lsv.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsv --version")

    output = pipe_output("#{bin}/lsv --init-config", "y\n", 0)
    assert_match "This will create lsv config at: #{testpath}/.config/lsv", output
    assert_match "About config.context passed to actions", (testpath/".config/lsv/init.lua").read
  end
end
