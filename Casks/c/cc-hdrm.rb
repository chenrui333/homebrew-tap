cask "cc-hdrm" do
  version "1.6.0"
  sha256 "19c91f578dd63d9003474e101b0debd390486c0cf55cf9cf2425ac64d03f9fa0"

  url "https://github.com/rajish/cc-hdrm/releases/download/v#{version}/cc-hdrm-#{version}.dmg"
  name "cc-hdrm"
  desc "Menu bar utility showing Claude subscription session headroom"
  homepage "https://github.com/rajish/cc-hdrm"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: :sonoma

  app "cc-hdrm.app"

  zap trash: [
    "~/Library/Application Support/cc-hdrm",
    "~/Library/Caches/com.cc-hdrm.app",
    "~/Library/HTTPStorages/com.cc-hdrm.app",
  ]
end
