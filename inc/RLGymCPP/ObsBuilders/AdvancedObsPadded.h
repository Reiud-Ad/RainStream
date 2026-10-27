#pragma once
#include "ObsBuilder.h"
#include <vector>

namespace RLGC {
    class AdvancedObsPadded : public ObsBuilder {
    public:
        int maxPlayersPerTeam;

        // Immer mit dem Maximum initialisieren (z.B. 3 für bis zu 3v3)
        AdvancedObsPadded(int maxPlayersPerTeam = 3);

        virtual FList BuildObs(const Player& player, const GameState& state) override;

    private:
        void AddPlayerToObs(FList& obs, const Player& player, bool inv, const PhysState& ball);
    };
}