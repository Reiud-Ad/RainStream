#pragma once

#include <rlbot/Bot.h>
#include <RLGymCPP/ObsBuilders/AdvancedObs.h>
#include <RLGymCPP/ObsBuilders/AdvancedObsPadded.h>
#include <RLGymCPP/ActionParsers/DefaultAction.h>
#include <GigaLearnCPP/InferUnit.h>

namespace GGL { class InferUnit; }

struct RLBotParams {
    int tickSkip;
    int actionDelay;
};

struct SharedBotContext {
    std::shared_ptr<RLGC::ObsBuilder> obs;
    std::shared_ptr<RLGC::ActionParser> act;

    // Three checkpoints, picked per match by team size (21.08.2026, user spec):
    //   1v1 -> Rain 100B, 2v2 -> Rain 86B, 3v3 -> Rain "68b".
    // 86B for 2v2 comes from a 10-pairing round robin at 1000 matches each: it beat every
    // other version (75.2% overall, vs 58.9% for 100B), while 100B stays for 1v1 and 68B
    // for 3v3. All three share the same obs builder, action parser and network shape, so
    // only the weights differ - that is what makes swapping them at runtime safe.
    std::shared_ptr<GGL::InferUnit> inferUnit1v1;
    std::shared_ptr<GGL::InferUnit> inferUnit2v2;
    std::shared_ptr<GGL::InferUnit> inferUnit3v3;

    RLBotParams params;
};

struct PlayerTimingState {
    float airTime = 0.f;
    float airTimeSinceJump = 0.f;
    bool  lastOnGround = true;
};

class RLBotBot : public rlbot::Bot {
public:
    struct PerBotState {
        bool initialized = false;

        // Queued action and current action
        RLGC::Action
            action = {},
            controls = {};
    };
    

    // Persistent info
    bool updateAction = true;
    int ticks = -1;
    float prevTime = 0;

    RLBotBot() noexcept = delete;
    ~RLBotBot() noexcept override;

    RLBotBot(std::unordered_set<unsigned> indices_,
        unsigned team_,
        std::string name_,
        std::shared_ptr<const SharedBotContext> ctx_) noexcept;

    void update(rlbot::flat::GamePacket const* packet_,
        rlbot::flat::BallPrediction const* ballPrediction_) noexcept override;

private:
    std::shared_ptr<const SharedBotContext> ctx_;
    std::unordered_map<unsigned, PerBotState> m_botState;
    std::vector<PlayerTimingState> m_playerTiming;
};
