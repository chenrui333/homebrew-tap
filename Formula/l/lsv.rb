class Lsv < Formula
  desc "Three Pane Terminal File Viewer"
  homepage "https://github.com/SecretDeveloper/lsv"
  url "https://static.crates.io/crates/lsv/lsv-0.1.14.crate"
  sha256 "0198dddefbe6fa429a6da2df16609974f4ad4402232c81f138689d318caf0b32"
  license "MIT"
  head "https://github.com/SecretDeveloper/lsv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "151cf84f1be22070785847d26cfc0f60bcd75be33877fccbab3aca14681692e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b365f37bc34cb6cb730c4f018a9441f42478db01d73c4bbd4fa2021e413936fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4dcd6c986ce3970945400615041441b0d649880e461249de649dc945c6f6f71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa77c43dcc0c08802cece6960ff825ed456adfe7401becdd95d073ddbe17735c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da58cfd33e89658cbc345541ef64daa5547274bc0d5a7bb58c1cf60a283852f6"
  end

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
